//
//  DataManager.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 19/12/2025.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class CharactersRepository: ObservableObject {
    let context: NSManagedObjectContext
    private let apiService: CharacterService
    
    init(context: NSManagedObjectContext, apiService: CharacterService = .shared) {
        self.context = context
        self.apiService = apiService
    }
    
    func fetchAndSaveCharacters() async {
        do {
            let characters = try await apiService.getCharacters()
            saveToCoreData(characters: characters)
        } catch {
            print("❌ error in CharactersRepository: \(error.localizedDescription)")
        }
    }
    
    private func saveToCoreData(characters: [Character]) {
        context.perform {
            for apiChar in characters {
                let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", apiChar.id)
                request.fetchLimit = 1
                
                let entity: CharacterEntity
                
                if let existing = try? self.context.fetch(request).first {
                    entity = existing
                } else {
                    entity = CharacterEntity(context: self.context)
                    entity.id = Int64(apiChar.id)
                    entity.isFavorite = false
                }
          
                entity.name = apiChar.name
                entity.status = apiChar.status
                entity.species = apiChar.species
                entity.gender = apiChar.gender
                entity.image = apiChar.image
                entity.originName = apiChar.origin.name
                entity.originUrl = apiChar.origin.url
            }
        }
        self.saveContext()
    }
  
    func toggleFavorite(entity: CharacterEntity) {
        if let url = entity.image {
            ImageService.shared.toggleFavorite(url: url)
        }
        self.saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("✅ saved to core data successfully")
            } catch {
                print("❌ error saving to Core Data: \(error.localizedDescription)")
            }
        }
    }
    
}
