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
    private let summaryView: SummaryView = SummaryView(tasksCount: 5, frame: .zero)
    
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
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .General.primary
        configureNavigationTitle()
        configureSearch()
        configureSummaryView()
        configureTable()
    }
    
    private func configureNavigationTitle() {
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.General.secondary
        ]
    }
    
    private func configureSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        
        let textField = search.searchBar.searchTextField
        let tintColor: UIColor = .SearchBar.tintColor
        textField.backgroundColor = .SearchBar.background
        textField.textColor = tintColor
        textField.tintColor = tintColor
        textField.leftView?.tintColor = tintColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: tintColor,
            ]
        )
        search.searchBar.tintColor = tintColor
        
        search.searchBar.showsBookmarkButton = true
        search.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        search.searchBar.tintColor = tintColor
        
        navigationItem.searchController = search
        definesPresentationContext = true
    }
    
    private func configureTable() {
        tableView.backgroundColor = .clear
        tableView.separatorColor = .systemGray
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        /// Added header to hide up separator for first row
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        header.backgroundColor = .clear
        tableView.tableHeaderView = header
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor)
        tableView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor)
        tableView.pinBottom(to: summaryView.topAnchor)
        tableAdapter.bind(tableView: tableView)
        tableAdapter.onSelect = { [weak self] id in
            self?.onItemTap?(id)
        }
    }
    
    func configureSummaryView() {
        summaryView.backgroundColor = .SummaryView.background
        view.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.pinBottom(to: view.bottomAnchor)
        summaryView.pinHorizontal(to: view)
        summaryView.setHeight(83)
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
