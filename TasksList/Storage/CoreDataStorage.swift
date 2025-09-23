//
//  CoreDataStorage.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation
import CoreData

final class CoreDataStorage: Storage {
    
    // MARK: - Properties
    private let operationManager: TaskOperationManager
    private let coreDataStack: CoreDataStack
    
    // MARK: - Singleton
    static let shared = CoreDataStorage()
    
    // MARK: - Initialization
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
        self.operationManager = TaskOperationManager(coreDataStack: coreDataStack)
    }
    
    // MARK: - Storage Protocol Implementation
    func fetchAll(completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        operationManager.fetchAllTasks(completion: completion)
    }
    
    func fetchTask(withId id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void) {
        operationManager.fetchTask(withId: id, completion: completion)
    }
    
    func delete(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        operationManager.deleteTask(withId: id, completion: completion)
    }
    
    func createTask(title: String, details: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        operationManager.createTask(title: title, description: details, completion: completion)
    }
    
    func updateTask(with id: UUID, title: String, details: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        operationManager.updateTask(with: id, title: title, description: details, completion: completion)
    }
    
    func initializeWithTasks(_ tasks: [TaskItem], completion: @escaping (Result<Void, Error>) -> Void) {
        deleteAllTasks { [weak self] result in
            switch result {
            case .success:
                // Затем создаем новые задачи
                self?.createTasks(tasks, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Additional Methods
    func toggleTaskStatus(withId id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        operationManager.toggleTaskStatus(withId: id, completion: completion)
    }
    
    func getTasksCount(completion: @escaping (Result<Int, Error>) -> Void) {
        operationManager.executeOnBackground {
            let context = self.coreDataStack.newBackgroundContext()
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            return try context.count(for: request)
        } completion: { result in
            completion(result)
        }
    }
    
    func getCompletedTasksCount(completion: @escaping (Result<Int, Error>) -> Void) {
        operationManager.executeOnBackground {
            let context = self.coreDataStack.newBackgroundContext()
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
            return try context.count(for: request)
        } completion: { result in
            completion(result)
        }
    }
    
    func fetchTasks(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        completion: @escaping (Result<[TaskItem], Error>) -> Void
    ) {
        let context = coreDataStack.newBackgroundContext()
        
        operationManager.executeOnBackground {
            let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            
            let todos = try context.fetch(request)
            return todos.map { $0.toDomainModel() }
        } completion: { result in
            completion(result)
        }
    }
    
    func deleteAllTasks(completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        
        operationManager.executeOnBackground {
            let request: NSFetchRequest<NSFetchRequestResult> = ToDo.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            try context.execute(deleteRequest)
            try context.save()
        } completion: { result in
            completion(result.map { _ in () })
        }
    }
    
    func createTasks(_ tasks: [TaskItem], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        
        operationManager.executeOnBackground {
            for task in tasks {
                _ = ToDo.fromDomainModel(task, context: context)
            }
            
            if context.hasChanges {
                try context.save()
            }
        } completion: { result in
            switch result {
            case .success:
                // Отправляем уведомления о создании задач
                DispatchQueue.main.async {
                    for task in tasks {
                        NotificationCenter.default.post(
                            name: TasksEvents.taskDidCreate,
                            object: nil,
                            userInfo: ["newTask": TasksEvents.CreatePayload(task: task)]
                        )
                    }
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Queue Management
    func suspendWriteOperations() {
        operationManager.suspendWriteOperations()
    }
    
    func resumeWriteOperations() {
        operationManager.resumeWriteOperations()
    }
    
    func cancelWriteOperations() {
        operationManager.cancelWriteOperations()
    }
    
    func suspendReadOperations() {
        operationManager.suspendReadOperations()
    }
    
    func resumeReadOperations() {
        operationManager.resumeReadOperations()
    }
    
    func cancelReadOperations() {
        operationManager.cancelReadOperations()
    }
    
    func waitForCompletion() {
        operationManager.waitForCompletion()
    }
}

// MARK: - Convenience Methods
extension CoreDataStorage {
    
    func fetchCompletedTasks(completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        let predicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchTasks(predicate: predicate, sortDescriptors: [sortDescriptor], completion: completion)
    }
    
    func fetchPendingTasks(completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        let predicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchTasks(predicate: predicate, sortDescriptors: [sortDescriptor], completion: completion)
    }
    
    func searchTasks(searchText: String, completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        let predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR details CONTAINS[cd] %@",
            searchText, searchText
        )
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchTasks(predicate: predicate, sortDescriptors: [sortDescriptor], completion: completion)
    }
}
