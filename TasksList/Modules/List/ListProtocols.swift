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
    func showEmpty()
    func showPopup(for id: UUID)
    func showIsLoading()
    func showError()
}

protocol ListViewOutput {
    func viewDidLoad()
    func searchChanged(query: String)
    func didTapAddButton()
    func didSelectItem(with id: UUID)
    func didTapEditButton(for id: UUID)
    func didTapShareButton(for id: UUID)
    func didTapDeleteButton(for id: UUID)
    func didHoldTaskCell(for id: UUID)
}

protocol ListInteractorInput {
    func filterItems(request: ListModels.FilterTasks.Request)
    func fetchItems(request: ListModels.LoadTasks.Request)
    func createItem(request: ListModels.CreateTask.Request)
    func deleteItem(request: ListModels.DeleteTask.Request)
    func getTaskInfo(request: ListModels.EditTask.Request)
    func shareItem(request: ListModels.ShareTask.Request)
}

protocol ListInteractorOutput: AnyObject {
    func didLoadItems(response: ListModels.LoadTasks.Response)
    func didFilteredItems(response: ListModels.FilterTasks.Response)
    func didCreateItem(response: ListModels.CreateTask.Response)
    func didDeleteItem(response: ListModels.DeleteTask.Response)
    func didLoadTaskInfo(response: ListModels.EditTask.Response)
    func didFailedToLoadTaskInfo(error: Error)
    func didShareItem(response: ListModels.ShareTask.Response)
}

protocol ListWorkerInput {
    func fetchItems(completion: @escaping (Result<[TaskItem], Error>) -> Void)
    func createItem()
    func deleteItem(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func getTaskInfo(with id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void)
    func editItem(with id: UUID)
    func shareItem(with id: UUID)
}

protocol ListRouterInput {
    func routeToCreate()
    func routeToEdit(taskId: UUID)
    func routeToShare()
}
