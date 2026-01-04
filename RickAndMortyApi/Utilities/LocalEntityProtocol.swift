//
//  LocalEntityProtocol.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 02/01/2026.
//

import Foundation

protocol LocalStorageService<Model> {
    associatedtype Model
    
    func fetchFavorites() -> [Model]
    func save(item: Model)
    func remove(id: Int64)
    func exists(id: Int64) -> Bool
}
