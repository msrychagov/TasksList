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
        
        enum Response {
            case success([TaskItem])
            case failure(Error)
        }
        
        struct ViewModel {
            let items: [ListItemViewModel]
        }
    }
    
    enum LoadTasksError: Error {
        
    }
}
