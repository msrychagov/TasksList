//
//  ListProtocoles.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import Foundation

protocol ListViewInput: AnyObject {
    func show(_ list: ListModels.LoadTasks.ViewModel)
    func showCell(_ viewModel: ListModels.LoadTasks.ViewModel.ListItemViewModel)
    func showPopup(for id: UUID)
    func showIsLoading()
    func showError()
}

protocol ListViewOutput {
    func viewDidLoad()
    func didTapAddButton()
    func didSelectItem(with id: UUID)
    func didTapEditButton(for id: UUID)
    func didTapShareButton(for id: UUID)
    func didTapDeleteButton(for id: UUID)
    func didHoldTaskCell(for id: UUID)
}

protocol ListInteractorInput {
    func loadItems(request: ListModels.LoadTasks.Request)
    func createItem(request: ListModels.LoadTasks.Request)
    func deleteItem(request: ListModels.LoadTasks.Request)
    func editItem(request: ListModels.LoadTasks.Request)
    func shareItem(request: ListModels.LoadTasks.Request)
}

protocol ListInteractorOutput: AnyObject {
    func didLoadItems(response: ListModels.LoadTasks.Response)
    func didCreateItem(response: ListModels.CreateTask.Response)
    func didDeleteItem(response: ListModels.DeleteTask.Response)
    func didEditItem(response: ListModels.EditTask.Response)
    func didShareItem(response: ListModels.ShareTask.Response)
}

protocol ListWorkerInput {
    func fetchItems()
    func createItem()
    func deleteItem(with id: UUID)
    func editItem(with id: UUID)
    func shareItem(with id: UUID)
}

protocol ListRouterInput {
    func routeToCreate()
    func routeToEdit()
    func routeToShare()
    func routeToDelete()
}
