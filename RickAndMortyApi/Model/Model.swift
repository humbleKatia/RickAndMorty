//
//  Model.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import UIKit

struct Results: Codable {
    var results: [Character]
}

struct Character: Codable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var gender: String
    var origin: Origin
    var image: String
}

struct Origin: Codable {
    var name: String
    var url: String
}

