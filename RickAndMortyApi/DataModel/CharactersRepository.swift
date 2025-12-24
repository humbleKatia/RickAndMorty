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
class CharacterRepository {
    static let shared = CharacterRepository()
    private let dataController = DataController.shared
    private let apiService = CharacterService.shared
    private var viewContext: NSManagedObjectContext {
        dataController.viewContext
    }
    
    private init() {}
    
    func fetchLocalData() throws -> [CharacterEntity] {
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CharacterEntity.id, ascending: true)]
        return try viewContext.fetch(request)
    }
    
    func syncData() async throws {
        let apiCharacters = try await apiService.getCharacters()
        let bgContext = dataController.newBackgroundContext()
        
        await bgContext.perform {
            for apiChar in apiCharacters {
                let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", Int64(apiChar.id))
                request.fetchLimit = 1
                
                let entity: CharacterEntity
                
                if let existing = try? bgContext.fetch(request).first {
                    entity = existing
                } else {
                    entity = CharacterEntity(context: bgContext)
                    entity.id = Int64(apiChar.id)
                    entity.isFavorite = false
                }
                
                entity.name = apiChar.name
                entity.status = apiChar.status
                entity.species = apiChar.species
                entity.gender = apiChar.gender
                entity.image = apiChar.image
                entity.lastUpdated = Date()
            }
        }
        self.dataController.save(context: bgContext)
    }
    
    func toggleFavorite(for entity: CharacterEntity) async throws -> Bool {
        let targetState = !entity.isFavorite
        let serverResult = try await apiService.setFavoriteStatus(id: entity.id, isFavorite: targetState)
        entity.isFavorite = serverResult
        entity.lastUpdated = Date()
        dataController.save()
        return true
    }
}


