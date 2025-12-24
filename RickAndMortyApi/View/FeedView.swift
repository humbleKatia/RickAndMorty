//
//  FeedView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 20/12/2025.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color.customBackground.ignoresSafeArea()
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.characters, id: \.self) { character in
                        CharacterCardView(imageUrl: character.image ?? "",
                                          name: character.name ?? "",
                                          status: character.status ?? "",
                                          species: character.species ?? "",
                                          gender: character.gender ?? "",
                                          isFavorite: character.isFavorite,
                                          onFavoriteToggle: {
                            return try await viewModel.toggleFavorite(for: character)
                        }
                        )
                    }
                }
                .padding(16)
            }
        }
        .task {
            await viewModel.loadData()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
}

