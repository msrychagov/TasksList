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
        <#code#>
    }
    
    func createItem(request: ListModels.LoadTasks.Request) {
        <#code#>
    }
    
    func deleteItem(request: ListModels.LoadTasks.Request) {
        <#code#>
    }
    
    func editItem(request: ListModels.LoadTasks.Request) {
        <#code#>
    }
    
    func shareItem(request: ListModels.LoadTasks.Request) {
        <#code#>
    }
}
