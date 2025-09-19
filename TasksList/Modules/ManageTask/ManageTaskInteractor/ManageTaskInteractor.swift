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
            output?.didFailToLoadTaskInfo(error: ManageTaskModels.Errors.tryingToCreateInsteadOfEdit)
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
    
    func createTask(request: ManageTaskModels.ShowInfo.Request) {
        print()
    }
    
    func updateTask(request: ManageTaskModels.ShowInfo.Request) {
        print()
    }
    
    
}
