//
//  TaskOperationManager.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation
import CoreData

class TaskOperationManager {
    // MARK: Queues
    private let readQueue: OperationQueue
    private let writeQueue: OperationQueue
    private let backgroundQueue: DispatchQueue
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
        
        readQueue = OperationQueue()
        readQueue.name = "TaskReadQueue"
        readQueue.maxConcurrentOperationCount = 3
        readQueue.qualityOfService = .userInitiated
        
        writeQueue = OperationQueue()
        writeQueue.name = "TaskWriteQueue"
        writeQueue.maxConcurrentOperationCount = 1
        writeQueue.qualityOfService = .userInitiated
        
        backgroundQueue = DispatchQueue(label: "TaskBackgroundQueue", qos: .userInitiated)
    }
    
    // MARK: - Public Methods
    func createTask(title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        let operation = CreateTaskOperation(context: context, title: title, description: description)
        
        operation.completion = { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        writeQueue.addOperation(operation)
    }
    
    func fetchAllTasks(completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        let operation = FetchAllTasksOperation(context: context)
        
        operation.completion = { result in
            switch result {
            case .success(let tasks):
                if let tasks = tasks as? [TaskItem] {
                    completion(.success(tasks))
                } else {
                    completion(.failure(StorageError.fetchError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        readQueue.addOperation(operation)
    }
    
    func fetchTask(withId id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        let operation = FetchTaskOperation(context: context, taskId: id)
        
        operation.completion = { result in
            switch result {
            case .success(let task):
                if let task = task as? TaskItem {
                    completion(.success(task))
                } else {
                    completion(.failure(StorageError.fetchError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        readQueue.addOperation(operation)
    }
    
    func updateTask(with id: UUID, title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        let operation = UpdateTaskOperation(context: context, taskId: id, title: title, description: description)
        
        operation.completion = { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        writeQueue.addOperation(operation)
    }
    
    func deleteTask(withId id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        let operation = DeleteTaskOperation(context: context, taskId: id)
        
        operation.completion = { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        writeQueue.addOperation(operation)
    }
    
    func toggleTaskStatus(withId id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        let operation = ToggleTaskStatusOperation(context: context, taskId: id)
        
        operation.completion = { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        writeQueue.addOperation(operation)
    }
    
    // MARK: - GCD Methods
    func executeOnBackground<T>(_ work: @escaping () throws -> T, completion: @escaping (Result<T, Error>) -> Void) {
        backgroundQueue.async {
            do {
                let result = try work()
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Queue Management
    func suspendWriteOperations() {
        writeQueue.isSuspended = true
    }
    
    func resumeWriteOperations() {
        writeQueue.isSuspended = false
    }
    
    func cancelWriteOperations() {
        writeQueue.cancelAllOperations()
    }
    
    func suspendReadOperations() {
        readQueue.isSuspended = true
    }
    
    func resumeReadOperations() {
        readQueue.isSuspended = false
    }
    
    func cancelReadOperations() {
        readQueue.cancelAllOperations()
    }
    
    func waitForCompletion() {
        writeQueue.waitUntilAllOperationsAreFinished()
        readQueue.waitUntilAllOperationsAreFinished()
    }
}
