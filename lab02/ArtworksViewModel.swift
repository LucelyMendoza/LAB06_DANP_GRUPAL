import Foundation
import Combine
import Firebase
import FirebaseFirestore

class ArtworksViewModel: ObservableObject {
    @Published var artworks: [ArtworkModel] = []
    private var lastDocId: String? = nil
    private let limit = 20

    init() {
        getArtworksFromAPI()
    }

    func loadMoreContent(currentItem item: ArtworkModel) {
        if let lastArtwork = artworks.last, lastArtwork.id == item.id {
            getArtworksFromAPI()
        }
    }

    // Nueva función para obtener obras de arte de la API
    func getArtworksFromAPI() {
        let apiUrl = "https://api.artic.edu/api/v1/artworks?page=1&limit=\(limit)" // Cambia el número de página según sea necesario
        guard let url = URL(string: apiUrl) else { return }
        let decoder = JSONDecoder()

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else { return }

            // Para depuración
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }

            do {
                let artworksResponse = try decoder.decode(Artworks.self, from: data)
                DispatchQueue.main.async {
                    // Agrega nuevas obras de arte a la lista
                    self?.artworks.append(contentsOf: artworksResponse.data)

                    // Guarda en Firestore
                    self?.saveArtworksToFirestore(artworks: artworksResponse.data)
                }
            } catch {
                print("Error decodificando datos: \(error)")
            }
        }.resume()
    }

    // Nueva función para guardar obras de arte en Firestore
    func saveArtworksToFirestore(artworks: [ArtworkModel]) {
        let db = Firestore.firestore() // Asegúrate de haber configurado Firestore correctamente

        for artwork in artworks {
            // Guarda cada obra de arte en Firestore
            db.collection("Paintings").document("\(artwork.id)").setData([
                "id": artwork.id,
                "title": artwork.title,
                "artistTitle": artwork.artistTitle ?? "",
                "imageId": artwork.imageId ?? ""
            ]) { error in
                if let error = error {
                    print("Error al guardar en Firestore: \(error)")
                } else {
                    print("Obra de arte guardada con éxito: \(artwork.title)")
                }
            }
        }
    }
}
