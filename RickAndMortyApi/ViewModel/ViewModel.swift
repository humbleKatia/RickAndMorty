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
    @Published var selectedSource: FeedSource = .rickAndMorty
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isloading: Bool = false
    // MARK: - Domain Models
    @Published var rnmCharacters: [RMCharacter] = []
    @Published var rnmFavorites: [RMCharacter] = []
    @Published var pokemons: [Pokemon] = []
    @Published var pokemonFavorites: [Pokemon] = []
    
    // MARK: - Dependencies
    private let rnmRepo: RickAndMortyRepository
    private let pokeRepo: PokemonRepository
    
    init(rnmRepo: RickAndMortyRepository, pokeRepo: PokemonRepository) {
        self.rnmRepo = rnmRepo
        self.pokeRepo = pokeRepo
        Task {
            self.isloading = true
            await loadData()
            self.isloading = false
        }
    }
    
    // MARK: - Loading
    func loadData() async {
        do {
            rnmFavorites = rnmRepo.fetchRMfromDB()
            pokemonFavorites = pokeRepo.fetchPokemonfromDB()
            self.rnmCharacters = try await rnmRepo.fetchRMFromNetwork()
            self.pokemons = try await pokeRepo.fetchPokemonFromNetwork()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - handleError
    private func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
        self.showError = true
    }
    
    // MARK: -  Rick & Morty
    func isFavorite(characterId: Int64) -> Bool {
        rnmFavorites.contains { $0.id == characterId }
    }
    
    func toggleRMFavorite(for character: RMCharacter) async -> Bool  {
        do {
            self.rnmFavorites = try await rnmRepo.togglePokeFavorite(for: character)
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    // MARK: - Pokemon
    func isPokeFavorite(id: Int64) -> Bool {
        pokemonFavorites.contains { $0.id == id }
    }
    
    func togglePokeFavorite(pokemon: Pokemon) async -> Bool {
        do {
            self.pokemonFavorites = try await pokeRepo.togglePokeFavorite(pokemon: pokemon)
            return true
        } catch {
            handleError(error)
            return false
        }
    }
}
