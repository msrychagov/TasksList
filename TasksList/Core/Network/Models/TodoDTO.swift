//
//  TodoDTO.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

// MARK: - API Response Models

/// Модель ответа от DummyJSON API
struct TodosResponse: Codable {
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

/// Модель задачи из DummyJSON API
struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

// MARK: - Domain Mapping Extension

extension TodoDTO {
    /// Преобразует TodoDTO в доменную модель TaskItem
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
    /// Преобразует массив TodoDTO в массив TaskItem
    func toDomainModels() -> [TaskItem] {
        return self.map { $0.toDomainModel() }
    }
}
