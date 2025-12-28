//
//  CoreDataFavoritesService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 28/12/2025.
//

import Foundation
import CoreData

class CoreDataFavoritesService: FavoritesServiceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }
    
    func fetchFavorites() -> [CharacterEntity] {
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func add(character: Character) {
        let entity = CharacterEntity(context: context)
        entity.id = Int64(character.id)
        entity.name = character.name
        entity.status = character.status
        entity.species = character.species
        entity.gender = character.gender
        entity.image = character.image
        entity.originName = character.origin.name
        entity.originUrl = character.origin.url
        entity.isFavorite = true
        save()
    }
    
    func remove(id: Int64) {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try context.fetch(fetchRequest)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                save()
            }
        } catch {
            print("Error deleting: \(error)")
        }
    }
    
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data: \(error)")
            }
        }
    }
}
