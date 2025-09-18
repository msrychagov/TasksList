//
//  TaskCell.swift
//  TasksList
//
//  Created by Михаил Рычагов on 16.09.2025.
//

import UIKit

final class ListTaskCell: UITableViewCell {
    // MARK: - ReuseIdentificator
    static let reuseId = "ListTaskCell"
    
    // MARK: - UI
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let doneButton = DoneButton()
    private let dateLabel = UILabel()
    
    // MARK: - State
    private var isDone = false
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Configure
    func configure(
        title: String,
        subtitle: String,
        isDone: Bool,
        date: String
    ) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        dateLabel.text = date
        self.isDone = isDone
    }
}

// MARK: - Private
private extension ListTaskCell {
    func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        preservesSuperviewLayoutMargins = true
        contentView.preservesSuperviewLayoutMargins = true
        contentView.insetsLayoutMarginsFromSafeArea = false
        
        configureDoneButton()
        configureTitle()
        configureSubtitle()
        configureDate()
    }
    
    func configureDoneButton() {
        doneButton.tintColor = .DoneButton.selected
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.pinTop(to: contentView.topAnchor)
        doneButton.pinLeft(to: contentView.layoutMarginsGuide.leadingAnchor)
        doneButton.setWidth(24)
        doneButton.setHeight(48)
    }
    
    func configureTitle() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.pinTop(to: contentView.topAnchor, 12)
        titleLabel.pinLeft(to: doneButton.trailingAnchor, 8)
        titleLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
        titleLabel.setHeight(22)
    }
    
    func configureSubtitle() {
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .General.secondary
        subtitleLabel.numberOfLines = 2
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, 6)
        subtitleLabel.pinLeft(to: titleLabel.leadingAnchor)
        subtitleLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
    }
    
    func configureDate() {
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .systemGray
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.pinTop(to: subtitleLabel.bottomAnchor, 6)
        dateLabel.pinLeft(to: titleLabel.leadingAnchor)
        dateLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
        dateLabel.setHeight(16)
        dateLabel.pinBottom(to: contentView.bottomAnchor, 12)
    }
}

