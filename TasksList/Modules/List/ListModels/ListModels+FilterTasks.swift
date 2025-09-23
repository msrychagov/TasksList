//
//  FilterTasks.swift
//  TasksList
//
//  Created by Михаил Рычагов on 18.09.2025.
//

extension ListModels {
    enum FilterTasks {
        struct Request {
            let query: String
        }
        
        enum Response {
            case success([TaskItem])
            case empty
        }
        
        struct ViewModel {
            let items: [ListItemViewModel]
        }
    }
}
