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
        interactor.loadItems(request: .init())
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
        print("hui")
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
                let vm = ListModels.LoadTasks.ViewModel(tasks: vms)
                DispatchQueue.main.async {
                    self.view?.show(vm)
                }
            }
        case .empty:
            print("пусто")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func didCreateItem(response: ListModels.CreateTask.Response) {
        print("hui")
    }
    
    func didDeleteItem(response: ListModels.DeleteTask.Response) {
        print("hui")
    }
    
    func didEditItem(response: ListModels.EditTask.Response) {
        print("hui")
    }
    
    func didShareItem(response: ListModels.ShareTask.Response) {
        print("hui")
    }
}
