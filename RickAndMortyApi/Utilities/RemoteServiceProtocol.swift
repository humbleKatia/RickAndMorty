//
//  RemoteServiceProtocol.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 28/12/2025.
//

import Foundation

protocol RemoteCharacter: Identifiable, Codable  {
    var id: Int64 { get }
}

protocol RemoteServiceProtocol {
    associatedtype Item: RemoteCharacter
    func fetchItems() async throws -> [Item]
    func setFavoriteStatus(id: Int64, isFavorite: Bool) async throws -> Bool
}


