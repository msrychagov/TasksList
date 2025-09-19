//
//  ManageTaskPresenter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

final class ManageTaskPresenter: ManageTaskViewOutput, ManageTaskInteractorOutput {
    // MARK: Connection Properties
    weak var view: ManageTaskViewInput?
    private let interactor: ManageTaskInteractorInput
    private let router: ManageTaskRouterInput
    
    // MARK: Lifecycle
    init(
        interactor: ManageTaskInteractorInput,
        router: ManageTaskRouterInput
    ) {
        self.interactor = interactor
        self.router = router
    }
}
