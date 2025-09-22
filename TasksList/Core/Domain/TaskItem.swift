//
//  TaskItem.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

struct TaskItem {
    let id: UUID
    let title: String
    let details: String?
    let isDone: Bool
    let date: Date
}
