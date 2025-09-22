//
//  ManageTaskWorker.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

final class ManageTaskWorker {
    // MARK: Conncection Properties
    private let storage: Storage
    
    // MARK: Lyfecycle
    init(storage: Storage) {
        self.storage = storage
    }
}

// MARK: ManageTaskWorkerInput Conforming
extension ManageTaskWorker: ManageTaskWorkerInput {
    func updateTask(with id: UUID, title: String, details: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        storage.updateTask(
            with: id,
            title: title,
            details: details,
            completion: completion
        )
    }
    
    func createTask(title: String, details: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        storage.createTask(
            title: title,
            details: details,
            completion: completion
        )
    }
    
    func loadTaskInfo(for id: UUID, completion: @escaping (Result<TaskItem, any Error>) -> Void) {
        storage.fetchTask(withId: id, completion: completion)
    }
    
    
}
