//
//  RickAndMortyApiApp.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

//@main
//struct RickAndMortyApiApp: App {
//    @StateObject private var viewModel = ViewModel(
//        apiService: RMService.shared,
//        databaseService: CoreDataFavoritesService()
//    )
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(viewModel)
//        }
//    }
//}
@main
struct RickAndMortyApiApp: App {
    // Create services once
    let rnmApi = RMService.shared
    let rnmDb = CoreDataFavoritesService() // Implements FavoritesServiceProtocol
    
    let pokeApi = PokemonService.shared
    let pokeDb = CoreDataPokemonService()  // Implements PokemonFavoritesProvider
    
    @StateObject private var viewModel: ViewModel

    init() {
        // Initialize StateObject with dependencies
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
            ContentView() // ContentView holds the FeedView
                .environmentObject(viewModel)
        }
    }
}
