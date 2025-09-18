//
//  ListTableAdapter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 16.09.2025.
//
import Foundation
import UIKit
final class ListTableAdapter: NSObject {
    enum Section { case main }
    struct Item: Hashable {
        let id: UUID
        let title: String
        let subtitle: String
        let isDone: Bool
        let date: String
    }
    
    // MARK: Properties
    private weak var tableView: UITableView?
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    var onSelect: ((UUID) -> Void)?
    
    // MARK: Table Settings Properties
    private let normalSeparatorInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    func bind(tableView: UITableView) {
        self.tableView = tableView
        tableView.register(ListTaskCell.self, forCellReuseIdentifier: ListTaskCell.reuseId)
        dataSource = .init(tableView: tableView) {
            tableView,
            indexPath,
            item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTaskCell.reuseId, for: indexPath) as! ListTaskCell
            cell.configure(
                title: item.title,
                subtitle: item.subtitle,
                isDone: item.isDone,
                date: item.date
            )
            return cell
        }
        tableView.delegate = self
    }
    
    func apply(cellVM: ListModels.LoadTasks.ViewModel) {
        let items = cellVM.tasks.map {
            Item(
                id: $0.id,
                title: $0.title,
                subtitle: $0.subTitle,
                isDone: $0.isDone,
                date: $0.date
            )
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension ListTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in }
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in }
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in }
            return UIMenu(title: "", children: [share, edit, delete])
        }
    }
}

