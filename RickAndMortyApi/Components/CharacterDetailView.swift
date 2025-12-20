//
//  CharacterDetailView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

struct CharacterDetailView: View {
    let imageUrl: String
    let name: String
    let status: String
    let species: String
    let gender: String
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                NetworkImage(imageUrl: imageUrl)
                    .frame(width: 170, height: 170)
                    .clipShape(Circle())
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Gender: ")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(gender)
                        .font(.title3)
                        .fontWeight(.regular)
                }
                HStack {
                    Text("Species: ")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(species)
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
    CharacterDetailView(imageUrl: "https://picsum.photos/200", name: "Rick Sanchez", status: "status", species: "species", gender: "male")
}
