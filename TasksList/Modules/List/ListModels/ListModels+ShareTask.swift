//
//  ShareTask.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

extension ListModels {
    enum ShareTask {
        struct Request {
            let id: UUID
        }
        
        struct Response {
            let task: TaskItem
        }
        
        struct ViewModel {
            let shareText: String
        }
    }
}
