//
//  PokemonModel.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 31/12/2025.
//

import Foundation

struct Pokemon: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let imageUrl: String
}

struct PokemonApiResponse: Codable {
    let results: [PokemonApiResult]
}

struct PokemonApiResult: Codable {
    let name: String
    let url: String // e.g., "https://pokeapi.co/api/v2/pokemon/1/"
}
