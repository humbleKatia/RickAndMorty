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
    
    var body: some View {
        ZStack {
               HStack(spacing: 8) {
                   NetworkImage(imageUrl: imageUrl)
                   .frame(width: height, height: height)
                   VStack {
                       //title, date, status, FavoriteButton
                       HStack(alignment: .top, spacing: 4) {
                           VStack(alignment: .leading, spacing: 8) {
                               Text(name)
                                   .foregroundStyle(.black)
                                   .lineLimit(2)
                               Text(status)
                                   .foregroundStyle(.black)
                           }
                           .frame(maxWidth: .infinity, alignment: .leading)
                          Image(systemName: "heart.fill")
                               .resizable()
                               .scaledToFit()
                           .frame(width: 34, height: 34)
                           .padding(.trailing, 4)
                       }
                       Spacer()
                       // Excursion tag, moreOrStatusButtonView
                       HStack(alignment: .bottom) {
                           Label(species, systemImage: "scope")
                               .foregroundStyle(.black)
                               .padding(.vertical, 14)
                           Spacer()
                       }
                   }
                   .frame(height: height)
               }
               .padding(4)
           }
           .background(Color.pink)
           .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CharacterCardView(imageUrl: "https://picsum.photos/200", name: "Rick Sanchez", status: "status", species: "species", gender: "male")
}
