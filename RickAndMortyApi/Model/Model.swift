//
//  Model.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import UIKit

struct Results: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int64
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Origin
    let image: String
    
}

struct Origin: Codable {
    let name: String
    let url: String
}

