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
        // Создаем модель программно
        let managedObjectModel = CoreDataStack.createManagedObjectModel()
        container = NSPersistentContainer(name: "TasksList", managedObjectModel: managedObjectModel)
        
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
    
    // MARK: - Private Methods
    
    private static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // Создаем entity для ToDo
        let taskEntity = NSEntityDescription()
        taskEntity.name = "ToDo"
        taskEntity.managedObjectClassName = "ToDo"
        
        // Создаем атрибуты
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = false
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = false
        
        let descriptionAttribute = NSAttributeDescription()
        descriptionAttribute.name = "taskDescription"
        descriptionAttribute.attributeType = .stringAttributeType
        descriptionAttribute.isOptional = true
        
        let isDoneAttribute = NSAttributeDescription()
        isDoneAttribute.name = "isDone"
        isDoneAttribute.attributeType = .booleanAttributeType
        isDoneAttribute.isOptional = false
        isDoneAttribute.defaultValue = false
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType
        dateAttribute.isOptional = false
        
        // Добавляем атрибуты к entity
        taskEntity.properties = [
            idAttribute,
            titleAttribute, 
            descriptionAttribute,
            isDoneAttribute,
            dateAttribute
        ]
        
        // Добавляем entity к модели
        model.entities = [taskEntity]
        
        return model
    }
}
