//
//  EmptyStateView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 04/01/2026.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView {
            VStack(spacing: 12) {
                BouncingHeart()
                Text("No Favorites")
                    .font(.headline)
                Text("You haven't added anything yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    EmptyStateView()
}
