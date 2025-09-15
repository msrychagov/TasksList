//
//  ListPresenter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

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
}
