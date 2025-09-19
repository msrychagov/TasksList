//
//  ManageTaskInteractor.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

final class ManageTaskInteractor: ManageTaskInteractorInput {
    // MARK: Connection Properties
    weak var output: ManageTaskInteractorOutput?
    private let worker: ManageTaskWorkerInput
    
    // MARK: Lifecycle
    init(worker: ManageTaskWorkerInput) {
        self.worker = worker
    }
}
