//
//  PokemonService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 31/12/2025.
//

import Foundation

class PokemonService: PokemonServiceProtocol {
    static let shared = PokemonService()
    private let urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
    
    init() {}
    
    func getPokemon() async throws -> [Pokemon] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(PokemonApiResponse.self, from: data)
       
        let pokemonList = apiResponse.results.compactMap { result -> Pokemon? in
            guard let id = extractId(from: result.url) else { return nil }
            return Pokemon(
                id: id,
                name: result.name.capitalized,
                imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
            )
        }
        return pokemonList
    }
    
    func setFavoriteStatus(id: Int64, isFavorite: Bool) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        // simulate server error
        // throw URLError(.badServerResponse)
        print("Pokemon API: post favorite status: ID \(id) -> \(isFavorite)")
        return isFavorite
    }
    
    // Helper to get "1" from "https://pokeapi.co/api/v2/pokemon/1/"
    private func extractId(from urlString: String) -> Int? {
        let cleanString = urlString.trimmingCharacters(in: .init(charactersIn: "/"))
        if let lastPart = cleanString.components(separatedBy: "/").last {
            return Int(lastPart)
        }
        return nil
    }
}
