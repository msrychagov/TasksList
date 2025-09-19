//
//  ManageTaskWorker.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

final class ManageTaskWorker: ManageTaskWorkerInput {
    // MARK: Conncection Properties
    private let storage: Storage
    
    // MARK: Lyfecycle
    init(storage: Storage) {
        self.storage = storage
    }
}
