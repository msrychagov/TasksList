//
//  TaskOperations.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import CoreData
import Foundation

// MARK: - Base Operation
class CoreDataOperation: Operation {
    let context: NSManagedObjectContext
    var completion: ((Result<Any, Error>) -> Void)?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    override func main() {
        context.performAndWait {
            executeOperation()
        }
    }
    
    func executeOperation() {
        // Должен быть переопределен в подклассах
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Create Task Operation
class CreateTaskOperation: CoreDataOperation {
    private let title: String
    private let details: String?
    
    init(context: NSManagedObjectContext, title: String, details: String?) {
        self.title = title
        self.details = details
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let newTask = TaskItem(
                id: UUID(),
                title: title,
                details: details,
                isDone: false,
                date: Date()
            )
            
            _ = CDTaskItem.fromDomainModel(newTask, context: context)
            try saveContext()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: TasksEvents.taskDidCreate,
                    object: nil,
                    userInfo: ["newTask": TasksEvents.CreatePayload(task: newTask)]
                )
                self.completion?(.success(()))
            }
        } catch {
            DispatchQueue.main.async {
                self.completion?(.failure(StorageError.coreDataError(error)))
            }
        }
    }
}

// MARK: - Fetch All Tasks Operation
class FetchAllTasksOperation: CoreDataOperation {
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<CDTaskItem> = CDTaskItem.fetchRequest()
            let cdTasks = try context.fetch(request)
            let tasks = cdTasks.map { $0.toDomainModel() }
            
            DispatchQueue.main.async {
                self.completion?(.success(tasks))
            }
        } catch {
            DispatchQueue.main.async {
                self.completion?(.failure(StorageError.fetchError))
            }
        }
    }
}

// MARK: - Fetch Task by ID Operation
class FetchTaskOperation: CoreDataOperation {
    private let taskId: UUID
    
    init(context: NSManagedObjectContext, taskId: UUID) {
        self.taskId = taskId
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<CDTaskItem> = CDTaskItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let cdTasks = try context.fetch(request)
            
            guard let cdTask = cdTasks.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            let task = cdTask.toDomainModel()
            DispatchQueue.main.async {
                self.completion?(.success(task))
            }
        } catch {
            DispatchQueue.main.async {
                self.completion?(.failure(StorageError.fetchError))
            }
        }
    }
}

// MARK: - Update Task Operation
class UpdateTaskOperation: CoreDataOperation {
    private let taskId: UUID
    private let title: String
    private let details: String?
    
    init(context: NSManagedObjectContext, taskId: UUID, title: String, details: String?) {
        self.taskId = taskId
        self.title = title
        self.details = details
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<CDTaskItem> = CDTaskItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let cdTasks = try context.fetch(request)
            
            guard let cdTask = cdTasks.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            cdTask.title = title
            cdTask.taskDescription = details
            
            try saveContext()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: TasksEvents.taskDidChange,
                    object: nil,
                    userInfo: ["changedTask": TasksEvents.UpdatedPayload(id: self.taskId)]
                )
                self.completion?(.success(()))
            }
        } catch {
            DispatchQueue.main.async {
                self.completion?(.failure(StorageError.coreDataError(error)))
            }
        }
    }
}

// MARK: - Delete Task Operation
class DeleteTaskOperation: CoreDataOperation {
    private let taskId: UUID
    
    init(context: NSManagedObjectContext, taskId: UUID) {
        self.taskId = taskId
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<CDTaskItem> = CDTaskItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let cdTasks = try context.fetch(request)
            
            guard let cdTask = cdTasks.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            context.delete(cdTask)
            try saveContext()
            
            DispatchQueue.main.async {
                self.completion?(.success(()))
            }
        } catch {
            DispatchQueue.main.async {
                self.completion?(.failure(StorageError.deleteError))
            }
        }
    }
}

// MARK: - Toggle Task Status Operation  
class ToggleTaskStatusOperation: CoreDataOperation {
    private let taskId: UUID
    
    init(context: NSManagedObjectContext, taskId: UUID) {
        self.taskId = taskId
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<CDTaskItem> = CDTaskItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let cdTasks = try context.fetch(request)
            
            guard let cdTask = cdTasks.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            cdTask.isDone = !cdTask.isDone
            try saveContext()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: TasksEvents.taskDidChange,
                    object: nil,
                    userInfo: ["changedTask": TasksEvents.UpdatedPayload(id: self.taskId)]
                )
                self.completion?(.success(()))
            }
        } catch {
            DispatchQueue.main.async {
                self.completion?(.failure(StorageError.coreDataError(error)))
            }
        }
    }
}
