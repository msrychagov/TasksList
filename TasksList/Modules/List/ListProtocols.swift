//
//  ListProtocoles.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import Foundation

protocol ListViewInput: AnyObject {
    func show(viewModel: ListModels.LoadTasks.ViewModel)
    func removeItem(viewModel: ListModels.DeleteTask.ViewModel)
    func reloadItem(viewModel: ListModels.EditTask.ViewModel)
    func insertItem(viewModel: ListModels.ListItemViewModel)
    func showEmpty()
    func showPopup(for id: UUID)
    func showIsLoading()
    func showError()
}

protocol ListViewOutput {
    func viewDidLoad()
    func searchChanged(query: String)
    func didSelectItem(with id: UUID)
    func didTapCreateButton()
    func didTapEditButton(for id: UUID)
    func didTapShareButton(for id: UUID)
    func didTapDeleteButton(for id: UUID)
    func didHoldTaskCell(for id: UUID)
}

protocol ListInteractorInput {
    func filterItems(request: ListModels.FilterTasks.Request)
    func fetchItems(request: ListModels.LoadTasks.Request)
    func createTask(request: ListModels.ManageTask.Request)
    func deleteItem(request: ListModels.DeleteTask.Request)
    func editTask(request: ListModels.ManageTask.Request)
    func shareItem(request: ListModels.ShareTask.Request)
}

protocol ListInteractorOutput: AnyObject {
    func didLoadItems(response: ListModels.LoadTasks.Response)
    func didFilteredItems(response: ListModels.FilterTasks.Response)
    func didRequestManageTask(response: ListModels.ManageTask.Response)
    func didDeleteItem(response: ListModels.DeleteTask.Response)
    func didFaileToEditTask(error: Error)
    func didShareItem(response: ListModels.ShareTask.Response)
    func didUpdateItem(response: ListModels.EditTask.Response)
    func didCreateItem(response: ListModels.CreateTask.Response)
}

protocol ListWorkerInput {
    func fetchItems(completion: @escaping (Result<[TaskItem], Error>) -> Void)
    func deleteItem(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func getTaskInfo(with id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void)
    func shareItem(with id: UUID)
}

protocol ListRouterInput {
    func routeToManageTaskView(mode: ManageMode)
    func routeToShare()
}
