//
//  RickAndMortyApiApp.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

@main
struct RickAndMortyApiApp: App {
    @StateObject private var viewModel = ViewModel(
        apiService: CharacterService.shared,
        databaseService: CoreDataFavoritesService()
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
