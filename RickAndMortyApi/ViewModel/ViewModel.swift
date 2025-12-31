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
    // MARK: - State
    @Published var selectedSource: FeedSource = .rickAndMorty
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // R&M Data
    @Published var rnmCharacters: [RMCharacter] = []
    @Published var rnmFavorites: [CharacterEntity] = []
    
    // Pokemon Data
    @Published var pokemons: [Pokemon] = []
    @Published var pokemonFavorites: [PokemonEntity] = []
    
    // MARK: - Dependencies
    // R&M Services
    private let rnmApi: CharacterServiceProtocol
    private let rnmDb: FavoritesServiceProtocol
    
    // Pokemon Services 
    private let pokeApi: PokemonServiceProtocol
    private let pokeDb: PokemonFavoritesProvider
    
    init(rnmApi: CharacterServiceProtocol,
         rnmDb: FavoritesServiceProtocol,
         pokeApi: PokemonServiceProtocol,
         pokeDb: PokemonFavoritesProvider) {
        
        self.rnmApi = rnmApi
        self.rnmDb = rnmDb
        self.pokeApi = pokeApi
        self.pokeDb = pokeDb
        
        Task { await loadData() }
    }
    
    // MARK: - Loading
    func loadData() async {
        rnmFavorites = rnmDb.fetchFavorites()
        pokemonFavorites = pokeDb.fetchFavorites()
        
        do {
            async let rnmData = rnmApi.getCharacters()
            async let pokeData = pokeApi.getPokemon()
            self.rnmCharacters = try await rnmData
            self.pokemons = try await pokeData
        } catch {
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
    
    // MARK: - Rick and Morty Logic
    func isFavorite(characterId: Int64) -> Bool {
        rnmFavorites.contains { $0.id == characterId }
    }
    
    func toggleFavorite(for character: RMCharacter) async -> Bool {
        let currentlyFavorite = isFavorite(characterId: character.id)
        let targetState = !currentlyFavorite
        
        do {
            let serverState = try await rnmApi
                .setFavoriteStatus(id: Int64(character.id), isFavorite: targetState)
            
            guard serverState == targetState else {
                print("server throws error, exit")
                return false
            }
            
            if targetState {
                rnmDb.add(character: character)
                print("added to core data")
            } else {
                rnmDb.remove(id: Int64(character.id))
                print("deleted from core data")
            }
    
            rnmFavorites = rnmDb.fetchFavorites()
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    func toggleFavorite(for entity: CharacterEntity) async -> Bool {
        do {
            let serverState = try await rnmApi
                .setFavoriteStatus(id: entity.id, isFavorite: false)
            guard serverState == false else { return false }
            rnmDb.remove(id: entity.id)
            rnmFavorites = rnmDb.fetchFavorites()
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    func removeFavorite(entity: CharacterEntity) async {
        do {
            let serverConfirmedState = try await rnmApi.setFavoriteStatus(id: entity.id, isFavorite: false)
            if !serverConfirmedState {
                rnmDb.remove(id: entity.id)
                rnmFavorites = rnmDb.fetchFavorites()
            }
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Pokemon Logic
    func isPokeFavorite(id: Int64) -> Bool {
        pokemonFavorites.contains { $0.id == id }
    }
    
    func togglePokeFavorite(pokemon: Pokemon) async -> Bool {
        let currentlyFavorite = isPokeFavorite(id: Int64(pokemon.id))
        let targetState = !currentlyFavorite
        
        do {
            let serverState = try await pokeApi
                .setFavoriteStatus(id: Int64(pokemon.id), isFavorite: targetState)
            
            guard serverState == targetState else {
                print("server throws error, exit")
                return false
            }
            
            if targetState {
                pokeDb.add(pokemon: pokemon)
                print("added to core data")
            } else {
                pokeDb.remove(id: Int64(pokemon.id))
                print("deleted from core data")
            }
            
            pokemonFavorites = pokeDb.fetchFavorites()
            return true
            
        } catch {
            handleError(error)
            return false
        }
    }
    
    func toggleFavoritePokemon(for entity: PokemonEntity) async -> Bool {
        do {
            let serverState = try await pokeApi
                .setFavoriteStatus(id: entity.id, isFavorite: false)
            guard serverState == false else { return false }
            pokeDb.remove(id: entity.id)
            pokemonFavorites = pokeDb.fetchFavorites()
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    func removeFavoritePokemon(entity: PokemonEntity) async {
        do {
            let serverConfirmedState = try await pokeApi.setFavoriteStatus(id: entity.id, isFavorite: false)
            if !serverConfirmedState {
                pokeDb.remove(id: entity.id)
                pokemonFavorites = pokeDb.fetchFavorites()
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
