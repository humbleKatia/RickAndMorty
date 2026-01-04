//
//  RickAndMortyApiApp.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

@main
struct RickAndMortyApiApp: App {
    @StateObject private var viewModel = ViewModel(rnmRepo: RickAndMortyRepository(api: RMService.shared, db: CoreDataRMService()),
                                                   pokeRepo: PokemonRepository(api: PokemonService.shared, db: CoreDataPokemonService()))

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
