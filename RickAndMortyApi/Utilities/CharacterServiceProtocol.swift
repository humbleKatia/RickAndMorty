//
//  CharacterServiceProtocol.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 28/12/2025.
//

import Foundation

protocol CharacterServiceProtocol {
    func getCharacters() async throws -> [Character]
    func setFavoriteStatus(id: Int64, isFavorite: Bool) async throws -> Bool
}
