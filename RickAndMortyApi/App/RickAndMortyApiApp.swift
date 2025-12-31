//
//  RickAndMortyApiApp.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

@main
struct RickAndMortyApiApp: App {
    let rnmApi = RMService.shared
    let rnmDb = CoreDataFavoritesService()
    
    let pokeApi = PokemonService.shared
    let pokeDb = CoreDataPokemonService()
    
    @StateObject private var viewModel: ViewModel

    init() {
        let vm = ViewModel(
            rnmApi: RMService.shared,
            rnmDb: CoreDataFavoritesService(),
            pokeApi: PokemonService.shared,
            pokeDb: CoreDataPokemonService()
        )
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
