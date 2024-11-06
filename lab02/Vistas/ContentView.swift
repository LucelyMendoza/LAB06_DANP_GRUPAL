import SwiftUI

struct ContentView: View {
    @Binding var isLoggedin: Bool

    var body: some View {
        TabView {
            NavigationView {
                HomeView(isLoggedin: $isLoggedin)
                    .navigationTitle("Home")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Logout") {
                                isLoggedin = false
                            }
                            .foregroundColor(.blue)
                        }
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationView {
                ArtworksView()
            }
            .tabItem {
                Label("Pinturas", systemImage: "paintpalette.fill")
            }
            
            NavigationView {
                QRCodeScannerView { scannedCode in
                    print(scannedCode)
                }
            }
            .tabItem {
                Label("QR", systemImage: "qr.fill")
            }

            NavigationView {
                MapaView()
            }
            .tabItem {
                Label("Mapa", systemImage: "map.fill")
            }
        }
    }
}
