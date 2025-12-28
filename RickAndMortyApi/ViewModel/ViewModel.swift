//
//  ViewModel.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 23/12/2025.
//

import Foundation
import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    @Published var allCharacters: [Character] = []
    @Published var favoriteCharacters: [CharacterEntity] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiService: CharacterServiceProtocol
    private let databaseService: FavoritesServiceProtocol
    
    init(apiService: CharacterServiceProtocol, databaseService: FavoritesServiceProtocol) {
        self.apiService = apiService
        self.databaseService = databaseService
        
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        // Load local data immediately
        favoriteCharacters = databaseService.fetchFavorites()
        
        // Load remote data
        do {
            allCharacters = try await apiService.getCharacters()
        } catch {
            handleError(error)
        }
    }
    
    func isFavorite(characterId: Int64) -> Bool {
        favoriteCharacters.contains { $0.id == characterId }
    }
    
    func toggleFavorite(for character: Character) async -> Bool {
        let currentlyFavorite = isFavorite(characterId: character.id)
        let targetState = !currentlyFavorite
        
        do {
            let serverState = try await apiService
                .setFavoriteStatus(id: Int64(character.id), isFavorite: targetState)
            
            guard serverState == targetState else {
                print("server throws error, exit")
                return false
            }
            
            if targetState {
                databaseService.add(character: character)
                print("added to core data")
            } else {
                databaseService.remove(id: Int64(character.id))
                print("deleted from core data")
            }
            
            favoriteCharacters = databaseService.fetchFavorites()
            return true
            
        } catch {
            handleError(error)
            return false
        }
    }
    
    func toggleFavorite(for entity: CharacterEntity) async -> Bool {
        do {
            let serverState = try await apiService
                .setFavoriteStatus(id: entity.id, isFavorite: false)
            guard serverState == false else { return false }
            databaseService.remove(id: entity.id)
            favoriteCharacters = databaseService.fetchFavorites()
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    func removeFavorite(entity: CharacterEntity) async {
        do {
            let serverConfirmedState = try await apiService.setFavoriteStatus(id: entity.id, isFavorite: false)
            if !serverConfirmedState {
                databaseService.remove(id: entity.id)
                favoriteCharacters = databaseService.fetchFavorites()
            }
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
        self.showError = true
    }
}

