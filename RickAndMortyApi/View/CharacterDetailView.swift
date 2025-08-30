//
//  CharacterDetailView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

struct CharacterDetailView: View {
    
    var character: Character
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .foregroundStyle(.secondary)
                }
                    .frame(width: 170, height: 170)
                Text(character.name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Gender: ")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(character.gender)
                        .font(.title3)
                        .fontWeight(.regular)
                }
                HStack {
                    Text("Species: ")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(character.species)
                        .font(.title3)
                        .fontWeight(.regular)
                }
                HStack {
                    Text("Origin: ")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(character.status)
                        .font(.title3)
                        .fontWeight(.regular)
                }
                HStack {
                    Text("Gender: ")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(character.gender)
                        .font(.title3)
                        .fontWeight(.regular)
                }
                HStack {
                    Text("Status: ")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(character.origin.name)
                        .font(.title3)
                        .fontWeight(.regular)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CharacterDetailView(character: MockData.shared.characterDetailView)
}
