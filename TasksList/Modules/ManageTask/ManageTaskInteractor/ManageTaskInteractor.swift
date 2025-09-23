//
//  ManageTaskInteractor.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

final class ManageTaskInteractor {
    // MARK: Connection Properties
    weak var output: ManageTaskInteractorOutput?
    private let worker: ManageTaskWorkerInput
    
    // MARK: Logic Properties
    private let mode: ManageMode
    
    // MARK: Lifecycle
    init(
        worker: ManageTaskWorkerInput,
        mode: ManageMode
    ) {
        self.worker = worker
        self.mode = mode
    }
}

// MARK: ManageTaskInteractorInput Conforming
extension ManageTaskInteractor: ManageTaskInteractorInput {
    func loadTaskInfo(request: ManageTaskModels.ShowInfo.Request) {
        switch mode {
        case .create:
            self.output?.didStartCreate(response: .init(date: Date()))
        case .edit(let id):
            worker.loadTaskInfo(for: id) { [weak self] result in
                switch result {
                case .success(let task):
                    self?.output?.didLoadTaskInfo(response: .init(task: task))
                case .failure(let error):
                    self?.output?.didFailToLoadTaskInfo(error: error)
                }
            }
        }
    }
    
    func saveTaskInfo(request: ManageTaskModels.SaveTaskInfo.Request) {
        guard !request.title.isEmpty else { return }
        let title = request.title
        let details = request.details
        switch mode {
        case .create:
            worker.createTask(
                title: title,
                details: details,
                completion: { [weak self] result in
                    switch result {
                    case .success:
                        /// The task has been successfully created, no additional logic is needed.
                        break
                    case .failure(let error):
                        self?.output?.didFailToCreateTask(error: error)
                    }
                }
            )
        case .edit(let id):
            worker.updateTask(
                with: id,
                title: title,
                details: details,
                completion: { [weak self] result in
                    switch result {
                    case .success:
                        /// The task has been successfully updated, no additional logic is needed.
                        break
                    case .failure(let error):
                        self?.output?.didFailToUpdateTask(error: error)
                    }
                }
            )
        }
    }
    
    func updateTitle(request: ManageTaskModels.UpdateTitle.Request) {
        let text = request.text
        output?.didUpdateTitle(response: .init(text: text))
    }
    
    func updateDescription(request: ManageTaskModels.UpdateDescription.Request) {
        let text = request.text
        output?.didUpdateDescription(response: .init(text: text))
    }
    
    
}
