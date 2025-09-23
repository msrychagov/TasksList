//
//  ListTableAdapter.swift
//  TasksList
//
//  Created by Михаил Рычагов on 23.09.2025.
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
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id }
    }
    
    // MARK: Properties
    private weak var tableView: UITableView?
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    private var itemsByID: [UUID: Item] = [:]
    private var pendingDeleteId: UUID?
    
    // MARK: Actions
    var onShare: ((UUID) -> Void)?
    var onDelete: ((UUID) -> Void)?
    var onEdit: ((UUID) -> Void)?
    var onToggleTask: ((UUID) -> Void)?
    
    // MARK: Table Settings Properties
    private var normalSeparatorInsets: UIEdgeInsets = .zero
    private var contextMenuIndexPath: IndexPath?
    
    func bind(tableView: UITableView) {
        self.tableView = tableView
        tableView.register(ListTaskCell.self, forCellReuseIdentifier: ListTaskCell.reuseId)
        normalSeparatorInsets = tableView.separatorInset
        dataSource = .init(tableView: tableView) { [weak self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTaskCell.reuseId, for: indexPath) as! ListTaskCell
            // Use the latest data from itemsByID to ensure reconfigure reflects updates
            let model = self?.itemsByID[item.id] ?? item
            cell.configure(
                title: model.title,
                subtitle: model.subtitle,
                isDone: model.isDone,
                date: model.date
            )
            cell.onToggleTask = { [weak self] in
                self?.onToggleTask?(item.id)
            }
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        tableView.delegate = self
    }
    
    func apply(cellVM: ListModels.LoadTasks.ViewModel) {
        let items = cellVM.items.map {
            Item(
                id: $0.id,
                title: $0.title,
                subtitle: $0.subTitle,
                isDone: $0.isDone,
                date: $0.date
            )
        }
        
        itemsByID = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func deleteItem(viewModel: ListModels.DeleteTask.ViewModel) {
        let id = viewModel.id
        
        var snapshot = dataSource.snapshot()
        if let item = snapshot.itemIdentifiers.first(where: { $0.id == id }) {
            snapshot.deleteItems([item])
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
                    self?.itemsByID.removeValue(forKey: id)
                }
            }
        }
    }
    
    func reloadItem(
        id: UUID,
        title: String,
        subtitle: String,
        isDone: Bool,
        date: String
    ) {
        itemsByID[id] = Item(
            id: id,
            title: title,
            subtitle: subtitle,
            isDone: isDone,
            date: date
        )

        var snapshot = dataSource.snapshot()
        guard let existing = snapshot.itemIdentifiers.first(where: { $0.id == id }) else { return }
        snapshot.reconfigureItems([existing])
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func insertItem(_ vm: ListModels.ListItemViewModel) {
        print(vm)
        let item = Item(id: vm.id, title: vm.title, subtitle: vm.subTitle, isDone: vm.isDone, date: vm.date)
        
        itemsByID[item.id] = item

        var snapshot = dataSource.snapshot()
        
        // Ensure the main section exists before adding items
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])
        }
        
        if let firstItem = snapshot.itemIdentifiers.first {
            snapshot.insertItems([item], beforeItem: firstItem)
        } else {
            snapshot.appendItems([item], toSection: .main)
        }

        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

}

// MARK: - UITableViewDelegate
extension ListTableAdapter: UITableViewDelegate {
    private func hideSeparator(for indexPath: IndexPath) {
        guard let cell = tableView?.cellForRow(at: indexPath) else { return }
        cell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
    }
    private func restoreSeparator(for indexPath: IndexPath) {
        guard let cell = tableView?.cellForRow(at: indexPath) else { return }
        cell.separatorInset = normalSeparatorInsets
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let id = item.id
        contextMenuIndexPath = indexPath
        hideSeparator(for: indexPath)
        let menu = UIContextMenuConfiguration(identifier: item.id as NSUUID, previewProvider: nil) { _ in
            let share = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up"),
                handler: { [weak self] _ in
                    self?.pendingDeleteId = nil
                    self?.onShare?(id)
                }
            )
            
            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { [weak self] _ in
                self?.pendingDeleteId = nil
                self?.onEdit?(id)
            }
            let delete = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.pendingDeleteId = id
                    self.tableView?.deselectRow(at: indexPath, animated: true)
                }
            return UIMenu(title: "", children: [share, edit, delete])
        }
        
        return menu
    }

    func tableView(_ tableView: UITableView,
                   willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionAnimating?) {
        guard let nsuuid = configuration.identifier as? NSUUID,
              let id = pendingDeleteId,
              id == nsuuid as UUID else {
            pendingDeleteId = nil
            if let idx = contextMenuIndexPath { restoreSeparator(for: idx) }
            contextMenuIndexPath = nil
            return
        }
        animator?.addCompletion { [weak self] in
            guard let self else { return }
            let deleteId = id
            self.pendingDeleteId = nil
            self.onDelete?(deleteId)
            if let idx = self.contextMenuIndexPath { self.restoreSeparator(for: idx) }
            self.contextMenuIndexPath = nil
        }
    }
}
