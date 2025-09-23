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
        viewController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func routeToShare(with text: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        // Настройка для iPad
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = viewController?.view
            popover.sourceRect = CGRect(x: viewController?.view.bounds.midX ?? 0,
                                      y: viewController?.view.bounds.midY ?? 0,
                                      width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController?.present(activityViewController, animated: true)
    }
}

