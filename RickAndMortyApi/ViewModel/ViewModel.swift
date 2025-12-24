//
//  ViewModel.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 23/12/2025.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
    @Published var characters: [CharacterEntity] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let repository = CharacterRepository.shared
    
    func loadData() async {
        do {
            self.characters = try repository.fetchLocalData()

            if characters.isEmpty  {
                print("load from server")
                try await repository.syncData()
                self.characters = try repository.fetchLocalData()
            }
        } catch {
            showError(error)
        }
    }
  
    func toggleFavorite(for character: CharacterEntity) async throws -> Bool {
        do {
            return try await repository.toggleFavorite(for: character)
        } catch {
            showError(error)
            return false
        }
    }

    private func showError(_ error: Error) {
        self.errorMessage = error.localizedDescription
        self.showError = true
    }
}
