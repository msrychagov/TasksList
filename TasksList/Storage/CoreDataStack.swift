//
//  CoreDataStack.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool = false) {
        // Используем скомпилированную модель из .xcdatamodeld
        container = NSPersistentContainer(name: "TasksList")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        let desc = container.persistentStoreDescriptions.first
        desc?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        desc?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data load error: \(error)")
                // В случае ошибки создаем новую базу
                self.recreateStore()
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    private func recreateStore() {
        let storeURL = container.persistentStoreDescriptions.first?.url
        if let url = storeURL {
            try? FileManager.default.removeItem(at: url)
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to create Core Data store: \(error)")
            }
        }
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
}
