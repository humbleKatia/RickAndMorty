//
//  FavoritesServiceProtocol.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 28/12/2025.
//

import Foundation

protocol FavoritesServiceProtocol {
    func fetchFavorites() -> [CharacterEntity]
    func add(character: Character)
    func remove(id: Int64)
}
