//
//  ToggleIsDone.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

extension ListModels {
    enum ToggleIsDone {
        struct Request {
            let id: UUID
        }
        
        enum Response {
            case success(TaskItem)
            case failure(Error)
        }
        
        struct ViewModel {
            let id: UUID
            let title: String
            let details: String
            let date: String
            let isDone: Bool
        }
    }
}
