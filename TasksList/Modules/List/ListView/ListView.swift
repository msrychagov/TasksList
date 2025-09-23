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
    private let summaryView: SummaryView = SummaryView(tasksCount: 0, frame: .zero)
    private let searchBarController = UISearchController(searchResultsController: nil)
    private let emptySearchResultView: EmptySearchResultView = EmptySearchResultView()
    private let emptyContainerView: UIView = UIView()
    
    // MARK: - Keyboard
    private var keyboardVisibleBottomInset: CGFloat = 0
    
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
        observeKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .General.primary
        configureNavigationBar()
        configureSearch()
        configureSummaryView()
        configureTable()
        configureEmptyStateContainer()
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
        tableView.backgroundColor = .General.primary
        tableView.separatorColor = .systemGray
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
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
        tableAdapter.onToggleTask = { [weak self] id in
            self?.output.didToggleTaskState(for: id)
        }
        tableAdapter.onShare = { [weak self] id in
            self?.output.didTapShareButton(for: id)
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
    
    private func configureEmptyStateContainer() {
        emptyContainerView.backgroundColor = .clear
        emptyContainerView.isHidden = true
        view.addSubview(emptyContainerView)
        emptyContainerView.translatesAutoresizingMaskIntoConstraints = false
        emptyContainerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        // Keep the container above the keyboard at all times
        emptyContainerView.pinBottom(to: view.keyboardLayoutGuide.topAnchor)
        emptyContainerView.pinLeft(to: view)
        emptyContainerView.pinRight(to: view)
        
        emptyContainerView.addSubview(emptySearchResultView)
        emptySearchResultView.translatesAutoresizingMaskIntoConstraints = false
        emptySearchResultView.pinCenterX(to: emptyContainerView)
        emptySearchResultView.pinCenterY(to: emptyContainerView)
        emptySearchResultView.pinLeft(to: emptyContainerView, 24)
        emptySearchResultView.pinRight(to: emptyContainerView, 24)
    }
    
    // MARK: - Keyboard Handling
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillChange(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        let endFrame = endFrameValue.cgRectValue
        let keyboardFrameInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardFrameInView)
        let bottomInset = max(0, intersection.height - view.safeAreaInsets.bottom)
        keyboardVisibleBottomInset = bottomInset
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            // Empty view is managed by constraints; ensure no residual transform
            self?.emptySearchResultView.transform = .identity
        })
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        keyboardVisibleBottomInset = 0
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            self?.emptySearchResultView.transform = .identity
        })
    }
    
    // MARK: - ListViewInput methods
    func show(viewModel: ListModels.LoadTasks.ViewModel) {
        emptyContainerView.isHidden = true
        tableView.separatorStyle = .singleLine
        emptySearchResultView.transform = .identity
        tableView.backgroundView = nil
        tableAdapter.apply(cellVM: viewModel)
        summaryView.setTasksCount(viewModel.items.count)
    }
    
    func showEmpty() {
        emptyContainerView.isHidden = false
        view.bringSubviewToFront(emptyContainerView)
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
        summaryView.setTasksCount(0)
    }
    
    func removeItem(viewModel: ListModels.DeleteTask.ViewModel) {
        tableAdapter.deleteItem(viewModel: viewModel)
        let currentRows = tableView.numberOfRows(inSection: 0)
        let newCount = max(0, currentRows - 1)
        summaryView.setTasksCount(newCount)
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
        let currentRows = tableView.numberOfRows(inSection: 0)
        summaryView.setTasksCount(currentRows + 1)
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
