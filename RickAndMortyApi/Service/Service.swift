//
//  Service.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import UIKit

protocol Service {
    func getCharacters() async throws -> [Character]
}

class CharacterService: Service {
    
    let baseURLString = "https://rickandmortyapi.com/api"
    var characters = "https://rickandmortyapi.com/api/character"

    
    func getCharacters() async throws -> [Character] {
        guard let url = URL(string: characters) else {
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



