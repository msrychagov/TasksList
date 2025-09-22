//
//  ManageTaskViewModelMapper.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

protocol ManageTaskViewModelMapper {
    func make(from task: TaskItem) -> ManageTaskModels.ManageTaskViewModel
}

// MARK: Default implementation
extension ManageTaskViewModelMapper {
    func make(from task: TaskItem) -> ManageTaskModels.ManageTaskViewModel {
        ManageTaskModels.ManageTaskViewModel(
            title: task.title,
            note: task.description ?? "",
            date: task.date.dmyslash()
            )
    }
}
