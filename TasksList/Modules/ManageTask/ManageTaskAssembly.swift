//
//  ManageTaskAssembly.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//
import UIKit
enum ManageTaskAssembly {
    static func build(mode: ManageMode) -> UIViewController {
        let storage = InMemoryStorage()
        let worker = ManageTaskWorker(storage: storage)
        let router = ManageTaskRouter()
        let interactor = ManageTaskInteractor(worker: worker, mode: mode)
        let presenter = ManageTaskPresenter(interactor: interactor, router: router)
        let view = ManageTaaskHostingVC(output: presenter)
        router.view = view
        interactor.output = presenter
        presenter.view = view
        
        return view
    }
}
