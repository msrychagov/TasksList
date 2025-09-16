//
//  ListItemViewModelMapper.swift
//  TasksList
//
//  Created by Михаил Рычагов on 16.09.2025.
//

import Foundation

protocol ListItemViewModelMapper {
    func make(from item: TaskItem) -> ListModels.LoadTasks.ViewModel.ListItemViewModel
}

// MARK: - Default Implementation
extension ListItemViewModelMapper {
    func make(from item: TaskItem) -> ListModels.LoadTasks.ViewModel.ListItemViewModel {
        return ListModels.LoadTasks.ViewModel.ListItemViewModel(
            id: item.id,
            title: item.title,
            subTitle: item.description ?? "",
            isDone: item.isDone,
            date: item.date.description
        )
    }
}
