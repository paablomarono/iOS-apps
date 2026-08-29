import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MeasureView()
                .tabItem {
                    Label("Medir", systemImage: "ruler")
                }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("Historial", systemImage: "clock")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

