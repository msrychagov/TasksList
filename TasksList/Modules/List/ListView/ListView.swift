//
//  ListViewController.swift
//  TasksList
//
//  Created by Михаил Рычагов on 14.09.2025.
//

import UIKit

final class ListViewController: UIViewController, ListViewInput {
    // MARK: - ListViewInputProperties
    private let output: ListViewOutput
    
    // MARK: TableAdapter
    private let tableAdapter: ListTableAdapter
    var onItemTap: ((UUID) -> Void)?
    
    // MARK: - UIProperties
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Lyfecycle
    init(
        output: ListViewOutput,
        tableAdapter: ListTableAdapter
    ) {
        self.output = output
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        configureUI()
    }
    
    // MARK: - ConfigureUI
    private func configureUI() {
        view.backgroundColor = .systemPink
        configureTable()
    }
    
    private func configureTable() {
        tableView.backgroundColor = .black
        tableView.separatorColor = .systemGray
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pin(to: view, 10)
        tableAdapter.bind(tableView: tableView)
        tableAdapter.onSelect = { [weak self] id in
            self?.onItemTap?(id)
        }
    }
    // MARK: - ListViewInput methods
    func show(_ list: ListModels.LoadTasks.ViewModel) {
        tableAdapter.apply(cellVM: list)
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
