import RealityKit
import UIKit
func createPointEntity(at position: SIMD3<Float>, color: UIColor = .systemRed) -> ModelEntity {
    let mesh = MeshResource.generateSphere(radius: 0.006)
    let material = SimpleMaterial(color: color, isMetallic: false)
    let entity = ModelEntity(mesh: mesh, materials: [material])
    entity.position = position
    return entity
}
func createLineEntity(from start: SIMD3<Float>, to end: SIMD3<Float>, color: UIColor = .systemYellow) -> ModelEntity {
    let distance = simd_distance(start, end)
    let mesh = MeshResource.generateBox(size: [0.002, 0.002, distance])
    let material = SimpleMaterial(color: color, isMetallic: false)
    let entity = ModelEntity(mesh: mesh, materials: [material])
    entity.position = (start + end) / 2
    entity.look(at: end, from: entity.position, relativeTo: nil)
    return entity
}
