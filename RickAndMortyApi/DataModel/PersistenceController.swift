//
//  PersistenceController.swift
//  RickAndMortyApi
//
//  Created by Ekaterina Lysova on 28/12/2025.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Core Data failed: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
