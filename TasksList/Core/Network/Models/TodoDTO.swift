//
//  TodoDTO.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

// MARK: - API Response Models
struct TodosResponse: Codable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

// MARK: - Domain Mapping Extension
extension TodoDTO {
    func toDomainModel() -> TaskItem {
        return TaskItem(
            id: UUID(),
            title: self.todo,
            details: nil,
            isDone: self.completed,
            date: Date()
        )
    }
}

extension Array where Element == TodoDTO {
    func toDomainModels() -> [TaskItem] {
        return self.map { $0.toDomainModel() }
    }
}
