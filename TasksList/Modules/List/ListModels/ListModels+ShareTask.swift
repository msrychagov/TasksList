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
            let task: TaskItem?
            let error: Error?
            
            init(task: TaskItem) {
                self.task = task
                self.error = nil
            }
            
            init(task: TaskItem?, error: Error) {
                self.task = task
                self.error = error
            }
        }
        
        struct ViewModel {
            let shareText: String
        }
    }
}
