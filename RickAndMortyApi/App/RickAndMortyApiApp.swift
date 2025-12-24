//
//  RickAndMortyApiApp.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 29/08/2025.
//

import SwiftUI

@main
struct RickAndMortyApiApp: App {
    @StateObject private var coreDataStack = DataController.shared
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                                    coreDataStack.persistentContainer.viewContext)
              
        }
    }
}
