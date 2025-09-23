//
//  ListPresenter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import Foundation

final class ListPresenter: ListViewOutput, ListInteractorOutput, ListItemViewModelMapper {
    // MARK: ListInteractorOutput Properties
    private let interactor: ListInteractorInput
    private let router: ListRouterInput
    weak var view: ListViewInput?
    
    // MARK: Properties
    private let mappingQueue = DispatchQueue(label: "list.presenter.mapping", qos: .userInitiated)
    // MARK: Lyfecycle
    init(
        interactor: ListInteractorInput,
        router: ListRouterInput
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ListViewOutput methods
    func viewDidLoad() {
        interactor.fetchItems(request: .init())
    }
    
    func searchChanged(query: String) {
        interactor.filterItems(request: .init(query: query))
    }
    
    func didTapCreateButton() {
        interactor.createTask(request: .init(id: nil))
    }
    
    
    
    func didTapEditButton(for id: UUID) {
        interactor.editTask(request: .init(id: id))
    }
    
    func didTapShareButton(for id: UUID) {
        interactor.shareItem(request: .init(id: id))
    }
    
    func didTapDeleteButton(for id: UUID) {
        interactor.deleteItem(request: .init(id: id))
    }
    
    func didToggleTaskState(for id: UUID) {
        interactor.toggleTaskState(request: .init(id: id))
    }
    
    
    
    // MARK: - ListInteractorOutput methods
    func didLoadItems(response: ListModels.LoadTasks.Response) {
        switch response {
        case .success(let items):
            mappingQueue.async { [weak self] in
                guard let self = self else { return }
                let vms = items.map{ self.make(from: $0) }
                let vm = ListModels.LoadTasks.ViewModel(items: vms)
                DispatchQueue.main.async {
                    self.view?.show(viewModel: vm)
                }
            }
        case .empty:
            print("пусто")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func didFilteredItems(response: ListModels.FilterTasks.Response) {
        switch response {
        case .success(let items):
            mappingQueue.async { [weak self] in
                guard let self = self else { return }
                let vms = items.map{ self.make(from: $0) }
                let vm = ListModels.LoadTasks.ViewModel(items: vms)
                DispatchQueue.main.async {
                    self.view?.show(viewModel: vm)
                }
            }
        case .empty:
            DispatchQueue.main.async {
                self.view?.show(viewModel: .init(items: []))
                self.view?.showEmpty()
            }
        }
    }
    
    func didDeleteItem(response: ListModels.DeleteTask.Response) {
        switch response {
        case .success(let id):
            view?.removeItem(viewModel: .init(id: id))
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func didToggleTaskState(response: ListModels.ToggleIsDone.Response) {
        switch response {
        case .success(let task):
            mappingQueue.async { [weak self] in
                guard let self else { return }
                let vm = self.make(from: task)
                DispatchQueue.main.async {
                    self.view?.reloadItem(
                        viewModel: .init(
                            id: vm.id,
                            title: vm.title,
                            details: vm.subTitle,
                            date: vm.date,
                            isDone: vm.isDone
                        )
                    )
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func didRequestManageTask(response: ListModels.ManageTask.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToManageTaskView(mode: response.mode)
        }
    }
    
    func didUpdateItem(response: ListModels.EditTask.Response) {
        mappingQueue.async { [weak self] in
            guard let self else { return }
            let vm = self.make(from: response.task)
            DispatchQueue.main.async {
                self.view?.reloadItem(
                    viewModel: .init(
                        id: vm.id,
                        title: vm.title,
                        details: vm.subTitle,
                        date: vm.date,
                        isDone: vm.isDone
                    )
                )
            }
        }
    }
    
    func didCreateItem(response: ListModels.CreateTask.Response) {
        mappingQueue.async { [weak self] in
            guard let self else { return }
            let vm = self.make(from: response.task)
            DispatchQueue.main.async {
                self.view?.insertItem(viewModel: vm)
            }
        }
    }
    
    func didFaileToEditTask(error: Error) {
        print(error.localizedDescription)
    }
    
    func didShareItem(response: ListModels.ShareTask.Response) {
        let task = response.task
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let shareText = "\"\(task.title)\"\n\(task.details ?? "Описание отсутствует")\n\nСоздано: \(dateFormatter.string(from: task.date))\nСтатус: \(task.isDone ? "✅ Выполнено" : "⏳ В процессе")"
        
        DispatchQueue.main.async { [weak self] in
            self?.router.routeToShare(with: shareText)
        }
    }
}

