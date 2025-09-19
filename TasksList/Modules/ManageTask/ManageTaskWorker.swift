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
        self.storage = InMemoryStorage.shared
    }
}

// MARK: ManageTaskWorkerInput Conforming
extension ManageTaskWorker: ManageTaskWorkerInput {
    func loadTaskInfo(for id: UUID, completion: @escaping (Result<TaskItem, any Error>) -> Void) {
        storage.fetchTask(withId: id, completion: completion)
    }
}
