//
//  ListModels.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

enum ListModels {
    struct ListItemViewModel {
        let id: UUID
        let title: String
        let subTitle: String
        let isDone: Bool
        let date: String
    }
    
    enum Errors: Error {
        case emptyID
    }
}
