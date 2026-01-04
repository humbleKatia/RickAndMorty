//
//  CharacterCardView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 19/12/2025.
//

import SwiftUI

struct CharacterCardView: View {
    let imageUrl: String
    let name: String
    let status: String
    let species: String
    let gender: String
    let height: CGFloat = 140
    @Binding var isFavorite: Bool
    @Binding var isloading: Bool
    let onFavoriteToggle: () async throws -> Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                NetworkImage(imageUrl: imageUrl)
                    .frame(width: height, height: height)
                    .skeleton(isLoading: $isloading)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack {
                    //name, status, favorite button
                    HStack(alignment: .top, spacing: 4) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(name)
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .skeleton(isLoading: $isloading)
                            HStack {
                                Circle()
                                    .fill(status == "Alive" ? .customGreen : .customRed)
                                    .frame(width: 10, height: 10)
                                    .skeleton(shape: .mask, isLoading: $isloading)
                                Text(status)
                                    .foregroundStyle(.customSecondaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .skeleton(isLoading: $isloading)
                            }
                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .skeleton(isLoading: $isloading)
                        FavoriteButton(isFavorite: $isFavorite) {
                            try await onFavoriteToggle()
                        }
                        .frame(width: 34, height: 34)
                        .padding(.trailing, 4)
                        .skeleton(shape: .mask, isLoading: $isloading, color: .pink.opacity(0.3))
                    }
                    Spacer()
                    //species
                    HStack(alignment: .bottom) {
                        Label(species, systemImage: "scope")
                            .foregroundStyle(.placeholder)
                            .padding(.vertical, 14)
                            .skeleton(shape: .mask, isLoading: $isloading)
                        Spacer()
                    }
                }
                .frame(height: height)
            }
            .padding(4)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


#Preview {
    CharacterCardView(imageUrl: "", name: "", status: "", species: "", gender: "", isFavorite: .constant(true), isloading: .constant(true)) {
        return true
    }
    .padding(16)
}
