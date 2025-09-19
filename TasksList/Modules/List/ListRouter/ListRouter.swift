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
    
    func routeToManageTaskView(mode: ManageMode) {
        let editVC = ManageTaskAssembly.build(mode: mode)
        viewController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func routeToShare() {
        print("hui")
    }
}
