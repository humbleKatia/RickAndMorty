//
//  ContentView.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

struct ContentView: View {

    @StateObject var vm = ViewModel(service: CharacterService())
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(vm.characters, id: \.id) { character in
                    NavigationLink(destination:  CharacterDetailView(character: character)) {
                        Text(character.name)
                    }

                }
            }
            .task {
                await vm.getCharacters()
            }
            .navigationTitle("The Rick and Morty")
        }
        .accentColor(Color(.red))
    }
}

#Preview {
    ContentView()
}




