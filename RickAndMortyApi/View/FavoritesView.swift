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
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.favoriteCharacters, id: \.id) { entity in
                        CharacterCardView(imageUrl: entity.image ?? "",
                                          name: entity.name ?? "",
                                          status: entity.status ?? "",
                                          species: entity.species ?? "",
                                          gender: entity.gender ?? "",
                                          isFavorite: .constant(true),
                                          onFavoriteToggle: {
                                            await viewModel.toggleFavorite(for: entity)
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

#Preview {
    FavoritesView()
}
