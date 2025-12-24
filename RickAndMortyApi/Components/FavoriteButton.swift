//
//  FavoriteButton.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 19/12/2025.
//

import SwiftUI

struct FavoriteButton: View {
    @State private var isLoading = false
    @Binding var isFavorite: Bool
    let onToggle: () async throws -> Bool
  
    var body: some View {
        Button {
            isLoading = true
            Task {
                if try await onToggle() {
                    isFavorite.toggle()
                }
                isLoading = false
            }
        } label: {
            if isLoading {
                ProgressView()
            } else {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(isFavorite ? .pink : .gray)
            }
        } .disabled(isLoading)
    }
}


