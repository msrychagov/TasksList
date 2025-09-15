//
//  ListProtocoles.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import Foundation

protocol ListViewInput: AnyObject {
    func showCell()
    func showPopup()
    func showIsLoading()
    func showError()
}

protocol ListViewOutput {
    func viewDidLoad()
    func didSelectItem()
    func didTapAddButton()
    func didTapEditButton()
    func didTapShareButton()
    func didTapDeleteButton()
    func didHoldTaskCell()
}

protocol ListInteractorInput {
    func loadItems()
    func createItem()
    func deleteItem()
    func editItem()
    func shareItem()
}

protocol ListInteractorOutput: AnyObject {
    func didLoadItems()
    func didFail()
    func didCreateItem()
    func didDeleteItem()
    func didEditItem()
    func didShareItem()
}

protocol ListWorkerInput {
    func fetchItems()
    func createItem()
    func deleteItem()
    func editItem()
    func shareItem()
}

protocol ListRouterInput {
    func routeToCreate()
    func routeToEdit()
    func routeToShare()
    func routeToDelete()
}
