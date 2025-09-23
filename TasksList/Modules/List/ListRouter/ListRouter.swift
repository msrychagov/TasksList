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
    func routeToManageTaskView(mode: ManageMode) {
        let editVC = ManageTaskAssembly.build(mode: mode)
        if Thread.isMainThread {
            viewController?.navigationController?.pushViewController(editVC, animated: true)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.navigationController?.pushViewController(editVC, animated: true)
            }
        }
    }
    
    func routeToShare(with text: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        if Thread.isMainThread {
            viewController?.present(activityViewController, animated: true)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.present(activityViewController, animated: true)
            }
        }
    }
}

