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

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "YourModelName") // имя файла .xcdatamodeld
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        let desc = container.persistentStoreDescriptions.first
        desc?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        desc?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

        container.loadPersistentStores { _, error in
            precondition(error == nil, "Core Data load error: \(String(describing: error))")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
}
