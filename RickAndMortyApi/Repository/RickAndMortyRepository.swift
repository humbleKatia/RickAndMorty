//
//  RickAndMortyRepository.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 01/01/2026.
//

import Foundation

final class RickAndMortyRepository {
    private let api: any RemoteServiceProtocol
    private let db: any LocalStorageService<RMCharacter>
    
    init(api: any RemoteServiceProtocol, db: any LocalStorageService<RMCharacter>) {
        self.api = api
        self.db = db
    }
    
    func fetchRMFromNetwork() async throws -> [RMCharacter] {
        do {
            return try await api.fetchItems() as! [RMCharacter]
        } catch {
            throw error
        }
    }
    
    func fetchRMfromDB() -> [RMCharacter] {
        return db.fetchFavorites()
    }
    
    func isFavorite(characterId: Int64) -> Bool {
        return db.exists(id: characterId)
    }
    
    func togglePokeFavorite(for character: RMCharacter) async throws -> [RMCharacter] {
        let currentlyFavorite = db.exists(id: character.id)
        let targetState = !currentlyFavorite
        
        do {
            let serverState = try await api
                .setFavoriteStatus(id: Int64(character.id), isFavorite: targetState)
            if targetState {
                db.save(item: character)
                print("added to core data")
            } else {
                db.remove(id: character.id)
                print("deleted from core data")
            }
        } catch {
            throw error
        }
        return db.fetchFavorites()
    }
    
}
