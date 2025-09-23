//
//  ListWorker.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

final class ListWorker: ListWorkerInput, StorageProvider {
    // MARK: - Properties
    private let storage: Storage
    
    // MARK: - Lefycycle
    init(storage: Storage) {
        self.storage = storage
    }
    // MARK: - ListWorkerInputMethods
    func fetchItems(completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        storage.fetchAll(completion: completion)
    }
    
    func deleteItem(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        storage.delete(id, completion: completion)
    }
    
    func getTaskInfo(with id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void) {
        storage.fetchTask(withId: id, completion: completion)
    }
    
    func shareItem(with id: UUID) {
        print("hui")
    }
    
    // MARK: - StorageProvider
    func getStorage() -> Storage {
        return storage
    }
}
