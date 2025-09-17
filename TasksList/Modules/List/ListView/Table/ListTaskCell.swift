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
    
    // MARK: - Proprties
    private var titleLabel: UILabel = UILabel()
    private var subtitleLabel: UILabel = UILabel()
    private var doneButton: UIButton = DoneButton()
    private var dateLabel: UILabel = UILabel()
    
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
        
        configureUI()
    }
    
    private func configureUI() {
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
    
    private func configureDoneButton() {
        doneButton.tintColor = .systemYellow
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.pinTop(to: contentView.topAnchor)
        doneButton.pinLeft(to: contentView.layoutMarginsGuide.leadingAnchor)
        doneButton.setWidth(24)
        doneButton.setHeight(48)
    }
    
    private func configureTitle() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .General.secondary
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.pinTop(to: contentView.topAnchor, 12)
        titleLabel.pinLeft(to: doneButton.trailingAnchor, 8)
        titleLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
        titleLabel.setHeight(22)
    }
    
    private func configureSubtitle() {
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .General.secondary
        subtitleLabel.numberOfLines = 2
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, 6)
        subtitleLabel.pinLeft(to: titleLabel.leadingAnchor)
        subtitleLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
        //        subtitleLabel.setHeight(32)
    }
    
    private func configureDate() {
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .General.secondary
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.pinTop(to: subtitleLabel.bottomAnchor, 6)
        dateLabel.pinLeft(to: titleLabel.leadingAnchor)
        dateLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
        dateLabel.setHeight(16)
        dateLabel.pinBottom(to: contentView.bottomAnchor, 12)
        
    }
}

extension ListTaskCell {
    enum Constraints {
        
    }
}
