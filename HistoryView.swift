import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \SavedMeasurement.date, order: .reverse) private var measurements: [SavedMeasurement]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(measurements) { m in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(m.name)
                                .font(.headline)
                            Text(m.date, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(m.formattedDistance)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                    }
                }
                .onDelete(perform: deleteMeasurements)
            }
            .navigationTitle("Historial")
            .overlay {
                if measurements.isEmpty {
                    ContentUnavailableView(
                        "Sin mediciones",
                        systemImage: "ruler",
                        description: Text("Las mediciones que guardes aparecerán aquí")
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addTestMeasurement()
                    } label: {
                        Label("Añadir prueba", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addTestMeasurement() {
        let randomDistance = Double.random(in: 0.1...3.0)
        let names = ["Mesa comedor", "Puerta", "Estantería", "Ventana", "Sofá"]
        let measurement = SavedMeasurement(
            name: names.randomElement() ?? "Objeto",
            distanceInMeters: randomDistance
        )
        modelContext.insert(measurement)
    }

    private func deleteMeasurements(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(measurements[index])
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .modelContainer(for: SavedMeasurement.self, inMemory: true)
    }
}
