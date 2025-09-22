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
    private let searchBarController = UISearchController(searchResultsController: nil)
    private let emptySearchResultView: EmptySearchResultView = EmptySearchResultView()
    
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
        configureNavigationBar()
        configureSearch()
        configureSummaryView()
        configureTable()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.General.secondary
        ]
        navigationController?.navigationBar.tintColor = .SummaryView.createButton
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    private func configureSearch() {
        let textField = searchBarController.searchBar.searchTextField
        
        /// Color setup
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
        searchBarController.searchBar.tintColor = tintColor
        
//        searchBarController.searchBar.scopeButtonTitles = ["Все", "Активные", "Завершенные"]
        searchBarController.searchBar.showsBookmarkButton = true
        searchBarController.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.hidesNavigationBarDuringPresentation = false
        searchBarController.searchResultsUpdater = self  // UISearchResultsUpdating
        navigationItem.searchController = searchBarController
        definesPresentationContext = true
    }
    
    private func configureTable() {
        tableView.backgroundColor = .clear
        tableView.separatorColor = .systemGray
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        
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
        tableAdapter.onEdit = { [weak self] id in
            self?.output.didTapEditButton(for: id)
        }
        tableAdapter.onDelete = { [weak self] id in
            self?.output.didTapDeleteButton(for: id)
        }
    }
    
    func configureSummaryView() {
        summaryView.backgroundColor = .SummaryView.background
        summaryView.onCreateTaskButtonTapped = { [weak self] in
            self?.output.didTapCreateButton()
        }
        view.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.pinBottom(to: view.bottomAnchor)
        summaryView.pinHorizontal(to: view)
        summaryView.setHeight(83)
    }
    
    // MARK: - ListViewInput methods
    func show(viewModel: ListModels.LoadTasks.ViewModel) {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
        tableAdapter.apply(cellVM: viewModel)
    }
    
    func showEmpty() {
        tableView.backgroundView = emptySearchResultView
        tableView.separatorStyle = .none
    }
    
    func removeItem(viewModel: ListModels.DeleteTask.ViewModel) {
        tableAdapter.deleteItem(viewModel: viewModel)
    }
    
    func reloadItem(viewModel: ListModels.EditTask.ViewModel) {
        tableAdapter.reloadItem(
            id: viewModel.id,
            title: viewModel.title,
            subtitle: viewModel.details,
            isDone: viewModel.isDone,
            date: viewModel.date
        )
    }
    
    func insertItem(viewModel: ListModels.ListItemViewModel) {
        tableAdapter.insertItem(viewModel)
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

// MARK: - SearchController Methods
extension ListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        output.searchChanged(query: text)
    }
    
    
}
