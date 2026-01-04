//
//  BouncingHeart.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 04/01/2026.
//

import SwiftUI

struct BouncingHeart: View {
    @State private var scale = false
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 48))
            .foregroundStyle(.red)
            .scaleEffect(scale ? 1.2 : 1.0)
            .frame(width: 60, height: 60)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: scale
            )
            .onAppear {
                scale = true
            }
            .onDisappear {
                scale = false
            }
    }
}
 
#Preview {
    BouncingHeart()
}
