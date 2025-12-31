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
                    LazyVStack(spacing: 8) {
                        if viewModel.selectedSource == .rickAndMorty {
                            rickAndMortyList
                        } else {
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
    
    // MARK: - Subviews for cleaner code
    var rickAndMortyList: some View {
        ForEach(viewModel.rnmCharacters, id: \.id) { character in
            let isFavorite = Binding<Bool>(
                get: {
                    viewModel.isFavorite(characterId: Int64(character.id))
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
                    await viewModel.toggleFavorite(for: character)
                }
            )
        }
    }
    
    var pokemonList: some View {
        ForEach(viewModel.pokemons, id: \.id) { pokemon in
            let isFavorite = Binding<Bool>(
                get: {
                    viewModel.isPokeFavorite(id: Int64(pokemon.id))
                },
                set: { _ in }
            )
            CharacterCardView(
                imageUrl: pokemon.imageUrl,
                name: pokemon.name,
                status: "",
                species: "",
                gender: "",
                isFavorite: isFavorite,
                onFavoriteToggle: {
                    await viewModel.togglePokeFavorite(pokemon: pokemon)
                }
            )
        }
    }
}
