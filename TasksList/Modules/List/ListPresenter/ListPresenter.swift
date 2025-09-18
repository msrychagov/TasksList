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
    
    func didTapAddButton() {
        print("hui")
    }
    
    func didSelectItem(with id: UUID) {
        print("hui")
    }
    
    func didTapEditButton(for id: UUID) {
        print("hui")
    }
    
    func didTapShareButton(for id: UUID) {
        print("hui")
    }
    
    func didTapDeleteButton(for id: UUID) {
        interactor.deleteItem(request: .init(id: id))
    }
    
    func didHoldTaskCell(for id: UUID) {
        print("hui")
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
    
    func didCreateItem(response: ListModels.CreateTask.Response) {
        print("hui")
    }
    
    func didDeleteItem(response: ListModels.DeleteTask.Response) {
        switch response {
        case .success(let id):
            view?.removeItem(viewModel: .init(id: id))
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func didEditItem(response: ListModels.EditTask.Response) {
        print("hui")
    }
    
    func didShareItem(response: ListModels.ShareTask.Response) {
        print("hui")
    }
}
