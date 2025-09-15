//
//  LoadTasks.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

extension ListEntity {
    enum LoadTasks {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {
            let id: UUID
            let title: String
            let subTitle: String
            let isDone: Bool
            let date: String
        }
    }
}
