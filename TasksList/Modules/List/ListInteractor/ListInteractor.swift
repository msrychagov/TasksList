//
//  ListInteractor.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//
import Foundation

final class ListInteractor: ListInteractorInput {
    
    // MARK: - Connection Properties
    private let worker: ListWorkerInput
    weak var output: ListInteractorOutput?
    
    // MARK: - Observer Properties
    private var token: NSObjectProtocol?
    
    // MARK: - Data
    private var allTasks: [TaskItem] = []
    
    // MARK: - Lyfecycle
    init(worker: ListWorkerInput) {
        self.worker = worker
        self.token = NotificationCenter.default.addObserver(
            forName: TasksEvents.taskDidChange,
            object: nil,
            queue: .main) { [weak self] note in
                guard
                    let self,
                    let p = note.userInfo?["payload"] as? TasksEvents.UpdatedPayload
                else { return }
                worker.getTaskInfo(with: p.id) { result in
                    switch result {
                    case .success(let task):
                        self.output?.didUpdateItem(response: .init(task: task))
                    case .failure(let error):
                        self.output?.didFaileToEditTask(error: error)
                    }
                }
            }
    }
    
    deinit {
        if let t = token {
            NotificationCenter.default.removeObserver(t)
        }
    }
    
    // MARK: ListInteractor InputMethods
    func fetchItems(request: ListModels.LoadTasks.Request) {
        worker.fetchItems { [weak self] result in
            switch result {
            case .success(let items):
                self?.allTasks = items
                let response: ListModels.LoadTasks.Response = items.isEmpty ? .empty : .success(items)
                self?.output?.didLoadItems(response: response)
            case.failure(let error):
                let response: ListModels.LoadTasks.Response = .failure(error)
                self?.output?.didLoadItems(response: response)
            }
        }
    }
    
    func filterItems(request: ListModels.FilterTasks.Request) {
        let query = request.query
        guard !query.isEmpty else {
            output?.didFilteredItems(response: .success(allTasks))
            return
        }
        let filteredTasks = allTasks.filter { $0.title.matched(with: query) }
        switch filteredTasks.count {
            case 0: output?.didFilteredItems(response: .empty)
            default: output?.didFilteredItems(response: .success(filteredTasks))
        }
    }
    
    func createTask(request: ListModels.ManageTask.Request) {
        print("hui")
    }
    
    func deleteItem(request: ListModels.DeleteTask.Request) {
        let id = request.id
        worker.deleteItem(with: id) { [weak self] result in
            switch result {
            case .success: self?.output?.didDeleteItem(response: .success(id))
            case .failure(let error): self?.output?.didDeleteItem(response: .failure(error))
            }
        }
    }
    
    func editTask(request: ListModels.ManageTask.Request) {
        guard let id = request.id else {
            self.output?.didFaileToEditTask(error: ListModels.Errors.emptyID)
            return
        }
        self.output?.didRequestManageTask(response: .init(mode: .edit(id)))
    }
    
    func shareItem(request: ListModels.ShareTask.Request) {
        print("hui")
    }
}
