//
//  PokemonRepository.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 01/01/2026.
//

import Foundation

class PokemonRepository {
    private let api: any RemoteServiceProtocol
    private let db: any LocalStorageService<Pokemon>
    
    init(api: any RemoteServiceProtocol, db: any LocalStorageService<Pokemon>) {
        self.api = api
        self.db = db
    }
    
    func fetchPokemonFromNetwork() async throws -> [Pokemon] {
        do {
            return try await api.fetchItems() as! [Pokemon]
        } catch {
            throw error
        }
    }
    
    func fetchPokemonfromDB() -> [Pokemon] {
        return db.fetchFavorites()
    }
    
    func isPokeFavorite(id: Int64) -> Bool {
        return db.exists(id: id)
    }
    
    func togglePokeFavorite(pokemon: Pokemon) async throws ->  [Pokemon]  {
        let currentlyFavorite = db.exists(id: pokemon.id)
        let targetState = !currentlyFavorite
        
        do {
            let serverState = try await api
                .setFavoriteStatus(id: Int64(pokemon.id), isFavorite: targetState)
            if targetState {
                db.save(item: pokemon)
                // Save Image Permanently
                ImageService.shared.saveToFavorites(urlString: pokemon.imageUrl)
                print("add to core data & Documents")
            } else {
                db.remove(id: pokemon.id)
                // Remove Image from Documents
                ImageService.shared.removeFromFavorites(urlString: pokemon.imageUrl)
                print("deleted from core data & Documents")
            }
        } catch {
            throw error
        }
        return db.fetchFavorites()
    }

}




