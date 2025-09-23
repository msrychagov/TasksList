//
//  TaskOperations.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import CoreData
import Foundation

// MARK: - Base Operation
class CoreDataOperation: Operation, @unchecked Sendable {
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
    
    func executeOperation() {}
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Create Task Operation
class CreateTaskOperation: CoreDataOperation, @unchecked Sendable {
    private let title: String
    private let taskDetails: String?
    
    init(context: NSManagedObjectContext, title: String, description: String?) {
        self.title = title
        self.taskDetails = description
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let newTask = TaskItem(
                id: UUID(),
                title: title,
                details: taskDetails,
                isDone: false,
                date: Date()
            )
            
            _ = ToDo.fromDomainModel(newTask, context: context)
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
class FetchAllTasksOperation: CoreDataOperation, @unchecked Sendable {
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
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
class FetchTaskOperation: CoreDataOperation, @unchecked Sendable {
    private let taskId: UUID
    
    init(context: NSManagedObjectContext, taskId: UUID) {
        self.taskId = taskId
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let todos = try context.fetch(request)
            
            guard let todo = todos.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            let task = todo.toDomainModel()
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
class UpdateTaskOperation: CoreDataOperation, @unchecked Sendable {
    private let taskId: UUID
    private let title: String
    private let taskDetails: String?
    
    init(context: NSManagedObjectContext, taskId: UUID, title: String, description: String?) {
        self.taskId = taskId
        self.title = title
        self.taskDetails = description
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let todos = try context.fetch(request)
            
            guard let todo = todos.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            todo.title = title
            todo.details = taskDetails
            
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
class DeleteTaskOperation: CoreDataOperation, @unchecked Sendable {
    private let taskId: UUID
    
    init(context: NSManagedObjectContext, taskId: UUID) {
        self.taskId = taskId
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let todos = try context.fetch(request)
            
            guard let todo = todos.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            context.delete(todo)
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
class ToggleTaskStatusOperation: CoreDataOperation, @unchecked Sendable {
    private let taskId: UUID
    
    init(context: NSManagedObjectContext, taskId: UUID) {
        self.taskId = taskId
        super.init(context: context)
    }
    
    override func executeOperation() {
        do {
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
            request.fetchLimit = 1
            
            let todos = try context.fetch(request)
            
            guard let todo = todos.first else {
                DispatchQueue.main.async {
                    self.completion?(.failure(StorageError.taskNotFound))
                }
                return
            }
            
            todo.done = !todo.done
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
