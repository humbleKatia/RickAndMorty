//
//  RMService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 20/12/2025.
//

import Foundation

class RMService: CharacterServiceProtocol {
    static let shared = RMService()
    private let urlString = "https://rickandmortyapi.com/api/character"
    
    init() {}
    
    func getCharacters() async throws -> [RMCharacter] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let results = try decoder.decode(Results.self, from: data)
        return results.results
    }
    
    func setFavoriteStatus(id: Int64, isFavorite: Bool) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        // simulate server error
        // throw URLError(.badServerResponse)
        print("post favorite status: ID \(id) -> \(isFavorite)")
        return isFavorite
    }
}
