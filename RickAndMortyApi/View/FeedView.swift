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
            VStack(spacing: 0) {
                SourcePicker(selectedSource: $viewModel.selectedSource)
                ScrollView {
                    VStack(spacing: 8) {
                        switch viewModel.selectedSource {
                        case .rickAndMorty:
                            rickAndMortyList
                        case .pokemon:
                            pokemonList
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
        ForEach(viewModel.rnmCharacters, id: \.id) { character in
            let isFavorite = Binding<Bool>(
                get: {
                    viewModel.isFavorite(characterId: character.id)
                },
                set: { _ in }
            )
            if viewModel.isloading {
                CharacterCardView(imageUrl: "", name: "", status: "", species: "", gender: "", isFavorite: .constant(true), isloading: $viewModel.isloading) {
                    return true
                }
            } else {
                CharacterCardView(
                    imageUrl: character.image,
                    name: character.name,
                    status: character.status,
                    species: character.species,
                    gender: character.gender,
                    isFavorite: isFavorite,
                    isloading: $viewModel.isloading,
                    onFavoriteToggle: {
                        await viewModel.toggleRMFavorite(for: character)
                    }
                )
            }
        }
    }
    
    var pokemonList: some View {
        ForEach(viewModel.pokemons, id: \.id) { pokemon in
            let isFavorite = Binding<Bool>(
                get: {
                    viewModel.isPokeFavorite(id: pokemon.id)
                },
                set: { _ in }
            )
            if viewModel.isloading {
                CharacterCardView(imageUrl: "", name: "", status: "", species: "", gender: "", isFavorite: .constant(true), isloading: $viewModel.isloading) {
                    return true
                }
            } else {
                CharacterCardView(
                    imageUrl: pokemon.imageUrl,
                    name: pokemon.name,
                    status: "Pokemon",
                    species: "Pokemon species",
                    gender: "Unknown",
                    isFavorite: isFavorite,
                    isloading: $viewModel.isloading,
                    onFavoriteToggle: {
                        await viewModel.togglePokeFavorite(pokemon: pokemon)
                    }
                )
            }
        }
    }
}
