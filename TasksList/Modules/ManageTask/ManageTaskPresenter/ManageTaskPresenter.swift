//
//  ManageTaskPresenter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

final class ManageTaskPresenter: ManageTaskViewOutput, ManageTaskInteractorOutput, ManageTaskViewModelMapper {
    // MARK: Connection Properties
    weak var view: ManageTaskViewInput?
    private let interactor: ManageTaskInteractorInput
    private let router: ManageTaskRouterInput
    
    // MARK: Mapping Properties
    private let mappingQueue = DispatchQueue(label: "manageTask.presenter.mapping", qos: .userInitiated)
    
    // MARK: Lifecycle
    init(
        interactor: ManageTaskInteractorInput,
        router: ManageTaskRouterInput
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: ManageTaskViewOutput Methods
    func onAppear() {
        interactor.loadTaskInfo(request: .init())
    }
    
    // MARK: ManageTaskInteractorOutput Methods
    func didLoadTaskInfo(response: ManageTaskModels.ShowInfo.Response) {
        let task = response.task
        mappingQueue.async {
            let info = self.make(from: task)
            DispatchQueue.main.async { [weak self] in
                self?.view?.showTaskInfo(viewModel: .init(info: info))
            }
        }
    }
    
    func didFailToLoadTaskInfo(error: any Error) {
        print(error.localizedDescription)
    }
}
