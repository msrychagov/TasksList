//
//  DiffableDataModels.swift
//  TasksList
//
//  Created by Михаил Рычагов on 23.09.2025.
//

import Foundation

// MARK: - Section для DiffableDataSource
enum ListSection: Int, CaseIterable, Hashable {
    case main
    
    var title: String {
        switch self {
        case .main:
            return "Tasks"
        }
    }
}

// MARK: - Item для DiffableDataSource
struct ListItem: Hashable {
    let id: UUID
    let title: String
    let subTitle: String
    let isDone: Bool
    let date: String
    
    init(from viewModel: ListModels.ListItemViewModel) {
        self.id = viewModel.id
        self.title = viewModel.title
        self.subTitle = viewModel.subTitle
        self.isDone = viewModel.isDone
        self.date = viewModel.date
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.subTitle == rhs.subTitle &&
               lhs.isDone == rhs.isDone &&
               lhs.date == rhs.date
    }
}