//
//  DeleteTask.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

extension ListModels {
    enum DeleteTask {
        struct Request {
            let id: UUID
        }
        
        enum Response {
            case success(UUID)
            case failure(Error)
        }
        
        struct ViewModel {
            let id: UUID
        }
    }
}
