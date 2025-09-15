//
//  ListViewController.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import UIKit

final class ListViewController: UIViewController, ListViewControllerProtocol {
    // MARK: - UIProperties
    private var titleLabel: UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureText()
    }
    
    private func configureText() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Hello, World!"
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 30)
        titleLabel.pinHorizontal(to: view, 30)
    }
}
