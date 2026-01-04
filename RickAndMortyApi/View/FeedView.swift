//
//  FeedView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 20/12/2025.
//

import SwiftUI

enum FeedSource: String, CaseIterable, Identifiable {
    case rickAndMorty = "Rick & Morty"
    case pokemon = "Pokemon"
    
    var id: String { self.rawValue }
}

struct FeedView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                Picker("Source", selection: $viewModel.selectedSource) {
                    ForEach(FeedSource.allCases) { source in
                        Text(source.rawValue).tag(source)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .background(.ultraThinMaterial)
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
            CharacterCardView(
                imageUrl: character.image,
                name: character.name,
                status: character.status,
                species: character.species,
                gender: character.gender,
                isFavorite: isFavorite,
                onFavoriteToggle: {
                    await viewModel.toggleRMFavorite(for: character)
                }
            )
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
            CharacterCardView(
                imageUrl: pokemon.imageUrl,
                name: pokemon.name,
                status: "Pokemon",
                species: "Pokemon species",
                gender: "Unknown",
                isFavorite: isFavorite,
                onFavoriteToggle: {
                    await viewModel.togglePokeFavorite(pokemon: pokemon)
                }
            )
        }
    }
}
