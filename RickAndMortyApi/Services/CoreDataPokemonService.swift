//
//  CoreDataPokemonService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 31/12/2025.
//

import Foundation
import CoreData

class CoreDataPokemonService: PokemonFavoritesProvider {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }
    
    func fetchFavorites() -> [PokemonEntity] {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func add(pokemon: Pokemon) {
        let entity = PokemonEntity(context: context)
        entity.id = Int64(pokemon.id)
        entity.name = pokemon.name
        entity.imageUrl = pokemon.imageUrl
        // If you added a 'type' attribute to your Entity, set it here:
        // entity.type = "Pokemon"
        entity.isFavorite = true
        save()
    }
    
    func remove(id: Int64) {
        print("Removing Pokemon from Core Data")
        let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try context.fetch(fetchRequest)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                save()
            }
        } catch {
            print("Error deleting Pokemon: \(error)")
        }
    }
    
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Pokemon Core Data: \(error)")
            }
        }
    }
}
