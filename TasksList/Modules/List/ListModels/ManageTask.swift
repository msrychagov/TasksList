//
//  ManageTask.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

extension ListModels {
    enum ManageTask {
        struct Request {
            let id: UUID?
        }
        
        struct Response {
            let mode: ManageMode
        }
    }
}
