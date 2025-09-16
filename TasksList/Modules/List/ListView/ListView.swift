//
//  ListViewController.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import UIKit

final class ListViewController: UIViewController, ListViewInput {
    // MARK: - Properties
    private let output: ListViewOutput
    
    // MARK: - UIProperties
    
    // MARK: - Lyfecycle
    init(output: ListViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }
    
    // MARK: ListViewInput methods
    func show(_ list: ListModels.LoadTasks.ViewModel) {
        print(list.tasks)
    }
    
    func showCell(_ viewModel: ListModels.LoadTasks.ViewModel.ListItemViewModel) {
        print("hui")
    }
    
    func showPopup(for id: UUID) {
        print("hui")
    }
    
    func showIsLoading() {
        print("hui")
    }
    
    func showError() {
        print("hui")
    }
}
