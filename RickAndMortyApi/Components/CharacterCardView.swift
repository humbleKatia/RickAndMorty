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
    let onFavoriteToggle: () async throws -> Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                NetworkImage(imageUrl: imageUrl)
                    .frame(width: height, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack {
                    //name, status, favorite button
                    HStack(alignment: .top, spacing: 4) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(name)
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                            HStack {
                                Circle()
                                    .fill(status == "Alive" ? .customGreen : .customRed)
                                    .frame(width: 10, height: 10)
                                Text(status)
                                    .foregroundStyle(.customSecondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        FavoriteButton(isFavorite: $isFavorite) {
                            try await onFavoriteToggle()
                        }
                        .frame(width: 34, height: 34)
                        .padding(.trailing, 4)
                    }
                    Spacer()
                    //species
                    HStack(alignment: .bottom) {
                        Label(species, systemImage: "scope")
                            .foregroundStyle(.placeholder)
                            .padding(.vertical, 14)
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


