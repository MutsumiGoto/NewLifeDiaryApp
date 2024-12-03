//
//  Persistent.swift
//  Checkpoint_4
//
//  Created by 後藤睦 on R 6/10/22.
//

import SwiftUI
import CoreData

struct PersistenceController {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CoreData")
        
        let description = NSPersistentStoreDescription()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Checkpoint_4.sqlite")
        description.url = storeURL
        
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    /// Function to reset Core Data by destroying the existing persistent store.
//    func resetPersistentStore() {
//        let storeCoordinator = container.persistentStoreCoordinator
//
//        // Check if the persistent store URL exists
//        guard let storeURL = storeCoordinator.persistentStores.first?.url else {
//            print("Persistent store URL not found.")
//            return
//        }
//
//        do {
//            // Destroy the existing persistent store
//            try storeCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
//
//            // Re-add the persistent store to initialize it
//            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//
//            print("Persistent store reset successfully.")
//        } catch {
//            print("Failed to reset persistent store: \(error)")
//        }
//    }
}


