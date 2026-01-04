//
//  PokemonModel.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 31/12/2025.
//

import Foundation

struct Pokemon: RemoteCharacter {
    let id: Int64
    let name: String
    let imageUrl: String
}

struct PokemonApiResponse: Codable {
    let results: [PokemonApiResult]
}

struct PokemonApiResult: Codable {
    let name: String
    let url: String 
}
