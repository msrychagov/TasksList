//
//  ListAssembly.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//
import UIKit

enum ListAssembly {
    static func build() -> UIViewController {
        let storage = InMemoryStorage()
        let router = ListRouter()
        let worker = ListWorker(storage: storage)
        let interactor = ListInteractor(worker: worker)
        let presenter = ListPresenter(interactor: interactor, router: router)
        let view = ListViewController(output: presenter)
        
        interactor.output = presenter
        presenter.view = view
        router.viewController = view
        
        return view
    }
}
