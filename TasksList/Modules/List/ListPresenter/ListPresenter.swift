//
//  ListPresenter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import Foundation

final class ListPresenter: ListViewOutput, ListInteractorOutput {
    // MARK: Properties
    private let interactor: ListInteractorInput
    private let router: ListRouterInput
    weak var view: ListViewInput?
    
    // MARK: Lyfecycle
    init(
        interactor: ListInteractorInput,
        router: ListRouterInput
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ListInteractorOutput methods
    func viewDidLoad() {
        <#code#>
    }
    
    func didTapAddButton() {
        <#code#>
    }
    
    func didSelectItem(with id: UUID) {
        <#code#>
    }
    
    func didTapEditButton(for id: UUID) {
        <#code#>
    }
    
    func didTapShareButton(for id: UUID) {
        <#code#>
    }
    
    func didTapDeleteButton(for id: UUID) {
        <#code#>
    }
    
    func didHoldTaskCell(for id: UUID) {
        <#code#>
    }
    
    // MARK: - ListInteractorOutput methods
    func didLoadItems(response: ListModels.LoadTasks.Response) {
        <#code#>
    }
    
    func didCreateItem(response: ListModels.CreateTask.Response) {
        <#code#>
    }
    
    func didDeleteItem(response: ListModels.DeleteTask.Response) {
        <#code#>
    }
    
    func didEditItem(response: ListModels.EditTask.Response) {
        <#code#>
    }
    
    func didShareItem(response: ListModels.ShareTask.Response) {
        <#code#>
    }
}
