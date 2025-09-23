//
//  ListItemViewModelMapper.swift
//  TasksList
//
//  Created by Михаил Рычагов on 16.09.2025.
//

import Foundation

protocol ListItemViewModelMapper {
    func make(from item: TaskItem) -> ListModels.ListItemViewModel
}

// MARK: - Default Implementation
extension ListItemViewModelMapper {
    func make(from item: TaskItem) -> ListModels.ListItemViewModel {
        return ListModels.ListItemViewModel(
            id: item.id,
            title: item.title,
            subTitle: item.details ?? "",
            isDone: item.isDone,
            date: item.date.dmyslash()
        )
    }
}
