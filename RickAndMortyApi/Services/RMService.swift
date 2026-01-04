//
//  RMService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 20/12/2025.
//

import Foundation

class RMService: RemoteServiceProtocol {
    static let shared = RMService()
    private let urlString = "https://rickandmortyapi.com/api/character"
    
    func fetchItems() async throws -> [RMCharacter] {
        try await Task.sleep(nanoseconds: 10_000_000_000) //Check Skeleton
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Results.self, from: data).results
    }
    
    func setFavoriteStatus(id: Int64, isFavorite: Bool) async throws -> Bool {
        try await Task.sleep(nanoseconds: 500_000_000) // Simulate network
        print("R&M API: ID \(id) -> \(isFavorite)")
        return isFavorite
    }
}
