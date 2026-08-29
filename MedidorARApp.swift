import SwiftUI
import SwiftData

@main
struct MedidorARApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedMeasurement.self)    }
}
