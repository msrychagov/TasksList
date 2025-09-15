//
//  CreateTask.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

extension ListEntities {
    enum CreateTask {
        struct Request {
            let title: String
            let description: String?
        }
        struct Response {
            let result: Result<TaskItem, CreateTaskError>
        }
        
        struct ViewModel {
            let state: State<ListEntity.ListItemViewModel>
        }
    }

    enum State<VM> {
        case success(VM)
        case failure(message: String)
    }

    enum CreateTaskError: Error {
        case emptyTitle
        case invalidDescription
        case network
    }
}
