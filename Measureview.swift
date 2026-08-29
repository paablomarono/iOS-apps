import SwiftUI
import SwiftData

struct MeasureView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var currentDistance: Float?
    @State private var showingSaveSheet = false
    @State private var measurementName = ""

    var body: some View {
        NavigationStack {
            ZStack {
                ARMeasureContainer { distance in
                    currentDistance = distance
                }
                // Ignoramos el borde superior (para que la cámara llegue
                // hasta arriba del todo, detrás del título), pero NO el
                // inferior — así dejamos siempre hueco libre para que la
                // barra de pestañas tenga su propio fondo normal, sin
                // competir visualmente con el renderizado de la cámara.
                .ignoresSafeArea(edges: [.top, .horizontal])

                VStack {
                    Spacer()

                    if currentDistance == nil {
                        Text("Toca dos puntos para medir")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial, in: Capsule())
                    }

                    Spacer()

                    if let distance = currentDistance {
                        VStack(spacing: 16) {
                            Text(formattedDistance(distance))
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .padding()
                                .background(.ultraThinMaterial, in: Capsule())

                            Button {
                                showingSaveSheet = true
                            } label: {
                                Label("Guardar", systemImage: "square.and.arrow.down")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .padding(.horizontal)
                            .allowsHitTesting(true)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .allowsHitTesting(currentDistance != nil)
            }
            .navigationTitle("Medir")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingSaveSheet) {
                saveSheet
            }
        }
    }

    private var saveSheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre (ej. Mesa comedor)", text: $measurementName)
                } header: {
                    Text("¿Qué has medido?")
                } footer: {
                    if let distance = currentDistance {
                        Text("Distancia: \(formattedDistance(distance))")
                    }
                }
            }
            .navigationTitle("Guardar medición")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        showingSaveSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveMeasurement()
                    }
                }
            }
        }
        .presentationDetents([.height(220)])
    }

    private func saveMeasurement() {
        guard let distance = currentDistance else { return }

        let saved = SavedMeasurement(
            name: measurementName.isEmpty ? "Medición" : measurementName,
            distanceInMeters: Double(distance)
        )
        modelContext.insert(saved)

        measurementName = ""
        currentDistance = nil
        showingSaveSheet = false
    }

    private func formattedDistance(_ meters: Float) -> String {
        let cm = meters * 100
        return cm < 100 ? String(format: "%.1f cm", cm) : String(format: "%.2f m", meters)
    }
}

// NOTA: no incluyo #Preview / PreviewProvider aquí a propósito.
// ARMeasureContainer necesita una cámara real y ARKit no funciona en el
// Canvas de Preview ni en el Simulador, así que un preview daría error o
// pantalla en negro. Para ver esta vista hay que correrla en un iPhone físico.

