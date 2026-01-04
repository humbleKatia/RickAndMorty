//
//  FavoritesView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 20/12/2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                SourcePicker(selectedSource: $viewModel.selectedSource)
                ScrollView {
                    VStack(spacing: 8) {
                        switch viewModel.selectedSource {
                        case .rickAndMorty:
                            if viewModel.rnmFavorites.isEmpty {
                                EmptyStateView()
                            } else {
                                rickAndMortyList
                            }
                        case .pokemon:
                            if viewModel.pokemonFavorites.isEmpty {
                                EmptyStateView()
                            } else {
                                pokemonList
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    var rickAndMortyList: some View {
        ForEach(viewModel.rnmFavorites, id: \.id) { entity in
            CharacterCardView(imageUrl: entity.image,
                              name: entity.name,
                              status: entity.status,
                              species: entity.species,
                              gender: entity.gender,
                              isFavorite: .constant(true),
                              isloading: $viewModel.isloading,
                              onFavoriteToggle: {
                await viewModel.toggleRMFavorite(for: entity)
            })
        }
    }
    
    var pokemonList: some View {
        ForEach(viewModel.pokemonFavorites, id: \.id) { entity in
            CharacterCardView(imageUrl: entity.imageUrl,
                              name: entity.name,
                              status:  "Pokemon",
                              species: "Pocket Monster",
                              gender: "",
                              isFavorite: .constant(true),
                              isloading: $viewModel.isloading,
                              onFavoriteToggle: {
                await viewModel.togglePokeFavorite(pokemon: entity)
            })
        }
    }
}

#Preview {
    FavoritesView()
}
