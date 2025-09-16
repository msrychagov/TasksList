//
//  ListWorker.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

final class ListWorker: ListWorkerInput {
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
    
    func createItem() {
        print("hui")
    }
    
    func deleteItem(with id: UUID) {
        print("hui")
    }
    
    func editItem(with id: UUID) {
        print("hui")
    }
    
    func shareItem(with id: UUID) {
        print("hui")
    }
}
