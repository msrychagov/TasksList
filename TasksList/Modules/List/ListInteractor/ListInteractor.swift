//
//  ListInteractor.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

final class ListInteractor: ListInteractorInput {
    // MARK: - Properties
    private let worker: ListWorkerInput
    weak var output: ListInteractorOutput?
    
    // MARK: - Lyfecycle
    init(worker: ListWorkerInput) {
        self.worker = worker
    }
    
    // MARK: ListInteractor InputMethods
    func loadItems(request: ListModels.LoadTasks.Request) {
        print("ура")
        worker.fetchItems { [weak self] result in
            switch result {
            case .success(let items):
                let response: ListModels.LoadTasks.Response = items.isEmpty ? .empty : .success(items)
                self?.output?.didLoadItems(response: response)
            case.failure(let error):
                let response: ListModels.LoadTasks.Response = .failure(error)
                self?.output?.didLoadItems(response: response)
            }
        }
    }
    
    func createItem(request: ListModels.LoadTasks.Request) {
        print("hui")
    }
    
    func deleteItem(request: ListModels.LoadTasks.Request) {
        print("hui")
    }
    
    func editItem(request: ListModels.LoadTasks.Request) {
        print("hui")
    }
    
    func shareItem(request: ListModels.LoadTasks.Request) {
        print("hui")
    }
}
