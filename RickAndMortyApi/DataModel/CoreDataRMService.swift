//
//  CoreDataRMService.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 28/12/2025.
//

import Foundation
import CoreData

class CoreDataRMService: LocalStorageService {
    typealias Model = RMCharacter 
    private let context = PersistenceController.shared.context
    
    func fetchFavorites() -> [RMCharacter] {
        let request: NSFetchRequest<RMEntity> = RMEntity.fetchRequest()
        guard let entities = try? context.fetch(request) else { return [] }
        // 2. Map Entity -> Struct
        return entities.map { entity in
            return RMCharacter(
                id: entity.id,
                name: entity.name ?? "",
                status: entity.status ?? "",
                species: entity.species ?? "",
                gender: entity.gender ?? "",
                origin: Origin(name: entity.originName ?? "", url: entity.originUrl ?? ""),
                image: entity.image ?? ""
            )
        }
    }
    
    func save(item: RMCharacter) {
        let request: NSFetchRequest<RMEntity> = RMEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", item.id)
        let entity: RMEntity
        if let existing = try? context.fetch(request).first {
            entity = existing
        } else {
            entity = RMEntity(context: context)
        }
        // Map Struct -> Entity
        entity.id = item.id
        entity.name = item.name
        entity.status = item.status
        entity.species = item.species
        entity.gender = item.gender
        entity.image = item.image
        entity.originName = item.origin.name
        entity.originUrl = item.origin.url
        entity.isFavorite = true
        PersistenceController.shared.save()
    }
    
    func remove(id: Int64) {
        let req: NSFetchRequest<RMEntity> = RMEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %d", id)
        if let target = try? context.fetch(req).first {
            context.delete(target)
            PersistenceController.shared.save()
        }
    }
    
    func exists(id: Int64) -> Bool {
        let req: NSFetchRequest<RMEntity> = RMEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %d", id)
        return (try? context.count(for: req)) ?? 0 > 0
    }
}
