//
//  CoreDataPokemonService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 31/12/2025.
//

import Foundation
import CoreData

class CoreDataPokemonService: LocalStorageService {
    typealias Model = Pokemon
    private let context = PersistenceController.shared.context
    
    func fetchFavorites() -> [Pokemon] {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        guard let entities = try? context.fetch(request) else { return [] }
        // MAPPING: Entity -> Struct
           return entities.map { entity in
               Pokemon(
                   id: entity.id,
                   name: entity.name ?? "",
                   imageUrl: entity.imageUrl ?? ""
               )
           }
    }
    
    func save(item: Pokemon) {
         let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
         request.predicate = NSPredicate(format: "id == %d", item.id)
         let entity: PokemonEntity
         if let existing = try? context.fetch(request).first {
             entity = existing
         } else {
             entity = PokemonEntity(context: context)
         }
         // MAPPING: Struct -> Entity
         entity.id = item.id
         entity.name = item.name
         entity.imageUrl = item.imageUrl
         entity.isFavorite = true
         PersistenceController.shared.save()
     }
     
     func remove(id: Int64) {
         let req: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
         req.predicate = NSPredicate(format: "id == %d", id)
         if let target = try? context.fetch(req).first {
             context.delete(target)
             PersistenceController.shared.save()
         }
     }
     
     func exists(id: Int64) -> Bool {
         let req: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
         req.predicate = NSPredicate(format: "id == %d", id)
         return (try? context.count(for: req)) ?? 0 > 0
     }
}
