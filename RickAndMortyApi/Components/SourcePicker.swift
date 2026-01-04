//
//  SourcePicker.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 04/01/2026.
//

import SwiftUI

enum FeedSource: String, CaseIterable, Identifiable {
    case rickAndMorty = "Rick & Morty"
    case pokemon = "Pokemon"
    
    var id: String { self.rawValue }
}

struct SourcePicker: View {
    @Binding var selectedSource: FeedSource
    
    var body: some View {
        Picker("Source", selection: $selectedSource) {
            ForEach(FeedSource.allCases) { source in
                Text(source.rawValue).tag(source)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .background(.ultraThinMaterial)
    }
}


