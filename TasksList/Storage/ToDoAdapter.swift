//
//  ToDoAdapter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import CoreData
import Foundation

// MARK: - ToDo Extensions for working with Domain Model
extension ToDo {
    func toDomainModel() -> TaskItem {
        return TaskItem(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            details: self.details,
            isDone: self.done,
            date: self.date ?? Date()
        )
    }
    
    static func fromDomainModel(_ taskItem: TaskItem, context: NSManagedObjectContext) -> ToDo {
        let todo = ToDo(context: context)
        todo.id = taskItem.id
        todo.title = taskItem.title
        todo.details = taskItem.details
        todo.done = taskItem.isDone
        todo.date = taskItem.date
        return todo
    }
    
    func updateFromDomainModel(_ taskItem: TaskItem) {
        self.title = taskItem.title
        self.details = taskItem.details
        self.done = taskItem.isDone
    }
}
