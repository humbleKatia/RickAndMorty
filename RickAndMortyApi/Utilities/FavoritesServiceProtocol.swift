//
//  FavoritesServiceProtocol.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 28/12/2025.
//

import Foundation

protocol FavoritesServiceProtocol {
    func fetchFavorites() -> [CharacterEntity]
    func add(character: RMCharacter)
    func remove(id: Int64)
}

protocol PokemonFavoritesProvider {
    func fetchFavorites() -> [PokemonEntity]
    func add(pokemon: Pokemon)
    func remove(id: Int64)
}
