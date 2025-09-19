//
//  ListRouter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import UIKit

final class ListRouter: ListRouterInput {
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - ListRouterInput methods
    func routeToCreate() {
        print("hui")
    }
    
    func routeToEdit(taskId: UUID) {
        let editVC = ManageTaskAssembly.build(taskId: taskId)
        viewController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func routeToShare() {
        print("hui")
    }
    
    func routeToDelete() {
        print("hui")
    }
}
