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
    
    func onDisappear(title: String, details: String) {
        interactor.saveTaskInfo(request: .init(title: title, details: details))
    }
    
    func onTitleChange(_ text: String) {
        interactor.updateTitle(request: .init(text: text))
    }
    
    func onDescriptionChange(_ text: String) {
        interactor.updateDescription(request: .init(text: text))
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
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(message: "Не удалось загрузить информацию о задаче: \(error.localizedDescription)")
        }
    }
    
    func didUpdateTitle(response: ManageTaskModels.UpdateTitle.Response) {
        let updatedTitle = response.text
        DispatchQueue.main.async { [weak self] in
            self?.view?.showUpdatedTitle(viewModel: .init(text: updatedTitle))
        }
    }
    
    func didUpdateDescription(response: ManageTaskModels.UpdateDescription.Response) {
        let updatedDescription = response.text
        DispatchQueue.main.async { [weak self] in
            self?.view?.showUpdatedDescription(viewModel: .init(text: updatedDescription))
        }
    }
    
    func didStartCreate(response: ManageTaskModels.Create.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showTaskInfo(
                viewModel: .init(
                    info: .init(
                        title: "",
                        note: "",
                        date: response.date.dmyslash()
                    )
                )
            )
        }
    }
    
    func didFailToCreateTask(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(message: "Не удалось создать задачу: \(error.localizedDescription)")
        }
    }
    
    func didFailToUpdateTask(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(message: "Не удалось обновить задачу: \(error.localizedDescription)")
        }
    }
}

extension ManageTaskPresenter: ManageTaskBackHandler {
    func onBackCommit(title: String, details: String) {
        interactor.saveTaskInfo(request: .init(title: title, details: details))
    }
}
