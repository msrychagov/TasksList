//
//  TasksEvents.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

enum TasksEvents {
    static let taskDidChange = Notification.Name("taskDidChange")
    static let taskDidCreate = Notification.Name("taskDidCreate")
    
    struct UpdatedPayload {
        let id: UUID
    }
    
    struct CreatePayload {
        let task: TaskItem
    }
}
