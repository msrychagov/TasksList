//
//  LoadTasks.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

extension ListModels {
    enum LoadTasks {
        struct Request {}
        
        struct Response {
            let result: Result<[TaskItem], LoadTasksError>
        }
        
        struct ViewModel {
            let state: State<[ListItemViewModel]>
            struct ListItemViewModel {
                let id: UUID
                let title: String
                let subTitle: String
                let isDone: Bool
                let date: String
            }
        }
    }
    
    enum LoadTasksError: Error {
        
    }
}
