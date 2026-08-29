import SwiftUI
import RealityKit
import ARKit

struct ARMeasureContainer: UIViewRepresentable {
    var onMeasurementComplete: (Float) -> Void

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)

        context.coordinator.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Por ahora, vacío
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: ARMeasureContainer
        weak var arView: ARView?
        private var points: [SIMD3<Float>] = []

        init(_ parent: ARMeasureContainer) {
            self.parent = parent
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            let screenLocation = sender.location(in: arView)

            // Si ya había una medición completa, un nuevo toque empieza otra desde cero.
            if points.count >= 2 {
                reset()
            }

            guard let result = arView.raycast(
                from: screenLocation,
                allowing: .estimatedPlane,
                alignment: .any
            ).first else {
                print("No se detectó ninguna superficie en ese punto todavía")
                return
            }

            let worldPosition = SIMD3<Float>(
                result.worldTransform.columns.3.x,
                result.worldTransform.columns.3.y,
                result.worldTransform.columns.3.z
            )

            addPoint(worldPosition)
        }

        private func addPoint(_ position: SIMD3<Float>) {
            guard let arView = arView else { return }

            // Dibuja la esfera en el punto tocado.
            let anchor = AnchorEntity(world: position)
            anchor.addChild(createPointEntity(at: .zero))
            arView.scene.addAnchor(anchor)

            points.append(position)

            // Si ya tenemos dos puntos, calculamos y dibujamos la línea entre ellos.
            if points.count == 2 {
                let distance = simd_distance(points[0], points[1])

                let lineAnchor = AnchorEntity(world: .zero)
                lineAnchor.addChild(createLineEntity(from: points[0], to: points[1]))
                arView.scene.addAnchor(lineAnchor)

                parent.onMeasurementComplete(distance)
            }
        }

        func reset() {
            arView?.scene.anchors.removeAll()
            points.removeAll()
        }
    }
}

