//
//  PokemonService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 31/12/2025.
//

import Foundation

class PokemonService: RemoteServiceProtocol {
    static let shared = PokemonService()
    private let urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
    
    func fetchItems() async throws -> [Pokemon] {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let apiResponse = try JSONDecoder().decode(PokemonApiResponse.self, from: data)
        return apiResponse.results.compactMap { result -> Pokemon? in
            guard let id = extractId(from: result.url) else { return nil }
            return Pokemon(
                id: id,
                name: result.name.capitalized,
                imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
            )
        }
    }
    
    func setFavoriteStatus(id: Int64, isFavorite: Bool) async throws -> Bool {
        try await Task.sleep(nanoseconds: 500_000_000)
        print("Pokemon API: ID \(id) -> \(isFavorite)")
        return isFavorite
    }
    
    private func extractId(from urlString: String) -> Int64? {
        let clean = urlString.trimmingCharacters(in: .init(charactersIn: "/"))
        if let last = clean.components(separatedBy: "/").last { return Int64(last) }
        return nil
    }
}
