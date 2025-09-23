//
//  ListAssembly.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//
import UIKit

enum ListAssembly {
    static func build() -> UIViewController {
        let storage = CoreDataStorage.shared
        let router = ListRouter()
        let worker = ListWorker(storage: storage)
        let appInitializationManager = AppInitializationManager()
        let interactor = ListInteractor(worker: worker, appInitializationManager: appInitializationManager)
        let presenter = ListPresenter(interactor: interactor, router: router)
        let tableAdapter = ListTableAdapter()
        let view = ListViewController(output: presenter, tableAdapter: tableAdapter)
        
        interactor.output = presenter
        presenter.view = view
        router.viewController = view
        
        return view
    }
}
