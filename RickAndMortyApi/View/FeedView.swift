//
//  FeedView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 20/12/2025.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.allCharacters, id: \.id) { character in
                        let isFavoriteBinding = Binding<Bool>(
                            get: {
                                viewModel.isFavorite(characterId: character.id)
                            },
                            set: { _ in }
                        )
                        CharacterCardView(imageUrl: character.image,
                                          name: character.name,
                                          status: character.status,
                                          species: character.species,
                                          gender: character.gender,
                                          isFavorite: isFavoriteBinding,
                                          onFavoriteToggle: {
                                            await viewModel.toggleFavorite(for: character)
                                        })
                    }
                }
                .padding(16)
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
}

