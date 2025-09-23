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
    private let appInitializationManager: AppInitializationManagerProtocol
    weak var output: ListInteractorOutput?
    
    // MARK: - Observer Properties
    private var tokenUpdate: NSObjectProtocol?
    private var tokenCreate: NSObjectProtocol?
    
    // MARK: - Data
    private var allTasks: [TaskItem] = []
    
    // MARK: - Lyfecycle
    init(worker: ListWorkerInput, appInitializationManager: AppInitializationManagerProtocol) {
        self.worker = worker
        self.appInitializationManager = appInitializationManager
        
        // Create
        self.tokenCreate = NotificationCenter.default.addObserver(
            forName: TasksEvents.taskDidCreate,
            object: nil,
            queue: .main) { [weak self] note in
                guard
                    let self,
                    let p = note.userInfo?["newTask"] as? TasksEvents.CreatePayload
                else { return }
                
                // Обновляем кэш allTasks с новой задачей и сортируем
                self.allTasks.append(p.task)
                self.allTasks.sort { $0.date > $1.date }
                
                self.output?.didCreateItem(response: .init(task: p.task))
            }
        // Update
        self.tokenUpdate = NotificationCenter.default.addObserver(
            forName: TasksEvents.taskDidChange,
            object: nil,
            queue: .main) { [weak self] note in
                guard
                    let self,
                    let p = note.userInfo?["changedTask"] as? TasksEvents.UpdatedPayload
                else { return }
                worker.getTaskInfo(with: p.id) { result in
                    switch result {
                    case .success(let task):
                        if let index = self.allTasks.firstIndex(where: { $0.id == task.id }) {
                            self.allTasks[index] = task
                            self.allTasks.sort { $0.date > $1.date }
                        }
                        self.output?.didUpdateItem(response: .init(task: task))
                    case .failure(let error):
                        self.output?.didFaileToEditTask(error: error)
                    }
                }
            }
    }
    
    deinit {
        if let tU = tokenUpdate { NotificationCenter.default.removeObserver(tU) }
        if let tC = tokenCreate { NotificationCenter.default.removeObserver(tC) }
    }
    
    // MARK: ListInteractor InputMethods
    func fetchItems(request: ListModels.LoadTasks.Request) {
        guard let storage = worker as? (any ListWorkerInput & StorageProvider) else {
            self.loadItemsDirectly()
            return
        }
        
        appInitializationManager.initializeAppIfNeeded(with: storage.getStorage()) { [weak self] result in
            switch result {
            case .success:
                self?.loadItemsDirectly()
            case .failure(let error):
                // Логируем ошибку инициализации, но продолжаем загрузку
                self?.loadItemsDirectly()
            }
        }
    }
    
    private func loadItemsDirectly() {
        worker.fetchItems { [weak self] result in
            switch result {
            case .success(let items):
                let sortedItems = items.sorted { $0.date > $1.date }
                self?.allTasks = sortedItems
                let response: ListModels.LoadTasks.Response = .success(sortedItems)
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
        let filteredTasks = allTasks
            .filter { $0.title.matched(with: query) }
            .sorted { $0.date > $1.date }
        switch filteredTasks.count {
            case 0: output?.didFilteredItems(response: .empty)
            default: output?.didFilteredItems(response: .success(filteredTasks))
        }
    }
    
    func createTask(request: ListModels.ManageTask.Request) {
        output?.didRequestManageTask(response: .init(mode: .create))
    }
    
    func deleteItem(request: ListModels.DeleteTask.Request) {
        let id = request.id
        worker.deleteItem(with: id) { [weak self] result in
            switch result {
            case .success: 
                self?.allTasks.removeAll { $0.id == id }
                self?.output?.didDeleteItem(response: .success(id))
            case .failure(let error): 
                self?.output?.didDeleteItem(response: .failure(error))
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
    
    func toggleTaskState(request: ListModels.ToggleIsDone.Request) {
        worker.toggleTaskState(with: request.id) { [weak self] result in
            switch result {
            case .success(let task):
                if let index = self?.allTasks.firstIndex(where: { $0.id == task.id }) {
                    self?.allTasks[index] = task
                }
                self?.output?.didToggleTaskState(response: .success(task))
            case .failure(let error):
                self?.output?.didToggleTaskState(response: .failure(error))
            }
        }
    }
    
    func shareItem(request: ListModels.ShareTask.Request) {
        worker.shareItem(with: request.id) { [weak self] result in
            switch result {
            case .success(let task):
                self?.output?.didShareItem(response: .init(task: task))
            case .failure(let error):
                self?.output?.didShareItem(response: .init(task: nil, error: error))
            }
        }
    }
}
