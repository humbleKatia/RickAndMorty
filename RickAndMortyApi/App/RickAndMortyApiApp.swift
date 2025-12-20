//
//  RickAndMortyApiApp.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

@main
struct RickAndMortyApiApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView(dataManager: CharactersRepository(context: dataController.container.viewContext))
                          .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
