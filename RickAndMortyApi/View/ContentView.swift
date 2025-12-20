//
//  ContentView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var dataManager: CharactersRepository
    @FetchRequest(sortDescriptors: []) var characters: FetchedResults<CharacterEntity>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(characters, id: \.self) { character in
                    CharacterCardView(imageUrl: character.image ?? "",
                                      name: character.name ?? "",
                                      status: character.status ?? "",
                                      species: character.species ?? "",
                                      gender: character.gender ?? "",
                                      isFavorite: Binding(
                                        get: { character.isFavorite },
                                        set: { newValue in
                                            character.isFavorite = newValue
                                        }
                                      ),
                                      onFavoriteToggle: {
                        dataManager.toggleFavorite(entity: character)
                                        return true
                                    }
                    )
                }
            }
            .padding(16)
        }
        .task {
            await dataManager.fetchAndSaveCharacters()
        }
    }
}


