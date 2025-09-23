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
    private var titleText: String = ""
    
    // MARK: - Callback
    var onToggleTask: (() -> Void)?
    
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
        self.titleText = title
        titleLabel.text = title
        subtitleLabel.text = subtitle
        dateLabel.text = date
        self.isDone = isDone
        
        updateUI()
    }
    
    // MARK: - Update UI based on isDone state
    private func updateUI() {
        doneButton.isSelected = isDone
        
        if isDone {
            titleLabel.textColor = .systemGray2
            titleLabel.attributedText = NSAttributedString(
                string: titleText,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            subtitleLabel.textColor = .systemGray3
        } else {
            titleLabel.textColor = .label
            // Всегда создаем новый NSAttributedString с явным сбросом всех атрибутов
            titleLabel.attributedText = NSAttributedString(
                string: titleText,
                attributes: [
                    .strikethroughStyle: 0,
                    .foregroundColor: UIColor.label
                ]
            )
            subtitleLabel.textColor = .General.secondary
        }
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
        doneButton.onTap = { [weak self] in
            self?.onToggleTask?()
        }
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.pinTop(to: contentView.topAnchor)
        doneButton.pinLeft(to: contentView.layoutMarginsGuide.leadingAnchor)
        doneButton.setWidth(UIConstants.Sizing.doneButtonWidth)
        doneButton.setHeight(UIConstants.Sizing.doneButtonHeight)
    }
    
    func configureTitle() {
        titleLabel.font = .systemFont(ofSize: UIConstants.Fonts.cellTitle, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.pinTop(to: contentView.topAnchor, UIConstants.Spacing.cellTitleTop)
        titleLabel.pinLeft(to: doneButton.trailingAnchor, UIConstants.Spacing.cellTitleLeftAfterIcon)
        titleLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
        titleLabel.setHeight(UIConstants.Sizing.cellTitleHeight)
    }
    
    func configureSubtitle() {
        subtitleLabel.font = .systemFont(ofSize: UIConstants.Fonts.cellSubtitle, weight: .regular)
        subtitleLabel.textColor = .General.secondary
        subtitleLabel.numberOfLines = 2
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, UIConstants.Spacing.cellSubtitleTop)
        subtitleLabel.pinLeft(to: titleLabel.leadingAnchor)
        subtitleLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
    }
    
    func configureDate() {
        dateLabel.font = .systemFont(ofSize: UIConstants.Fonts.cellSubtitle, weight: .regular)
        dateLabel.textColor = .systemGray
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.pinTop(to: subtitleLabel.bottomAnchor, UIConstants.Spacing.cellDateTop)
        dateLabel.pinLeft(to: titleLabel.leadingAnchor)
        dateLabel.pinRight(to: contentView.layoutMarginsGuide.trailingAnchor)
        dateLabel.setHeight(UIConstants.Sizing.dateLabelHeight)
        dateLabel.pinBottom(to: contentView.bottomAnchor, UIConstants.Spacing.cellDateBottom)
    }
}

