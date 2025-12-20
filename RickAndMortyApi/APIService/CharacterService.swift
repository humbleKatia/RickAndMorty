//
//  CharacterService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 20/12/2025.
//

import Foundation

class CharacterService {
    static let shared = CharacterService()
    var url = "https://rickandmortyapi.com/api/character"
    
    private init() {}
    
    func getCharacters() async throws -> [Character] {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let results = try? decoder.decode(Results.self, from: data) else {
            throw URLError(.cannotParseResponse)
        }
        return results.results
    }
    
}
