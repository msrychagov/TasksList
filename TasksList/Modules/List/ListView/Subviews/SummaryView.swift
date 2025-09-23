//
//  BottomBarView.swift
//  TasksList
//
//  Created by Михаил Рычагов on 17.09.2025.
//

import UIKit

final class SummaryView: UIView {
    // MARK: - Properties
    private var tasksCount: Int
    
    // MARK: - Actions Propeties
    var onCreateTaskButtonTapped: (() -> Void)?
    
    // MARK: - UI Properties
    private let summaryLabel: UILabel = UILabel()
    private let createTaskButton: UIButton = UIButton(type: .system)
    private let border: UIView = UIView()
    
    
    // MARK: Lyfecycle
    init(tasksCount: Int, frame: CGRect) {
        self.tasksCount = tasksCount
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        configureBorder()
        configureSummaryLabel()
        configureCreateTaskButton()
    }
    
    private func configureBorder() {
        border.backgroundColor = .SummaryView.border
        self.addSubview(border)
        border.pinTop(to: self.topAnchor)
        border.setHeight(UIConstants.Sizing.summaryBorderHeight)
        border.pinHorizontal(to: self)
    }
    
    private func configureSummaryLabel() {
        summaryLabel.text = "\(tasksCount) \(tasksWord(for: tasksCount))"
        summaryLabel.font = .systemFont(ofSize: UIConstants.Fonts.summaryLabel, weight: .regular)
        summaryLabel.tintColor = .SummaryView.text
        self.addSubview(summaryLabel)
        summaryLabel.pinTop(to: border.bottomAnchor, UIConstants.Spacing.summaryTopToBorder)
        summaryLabel.pinCenterX(to: self.centerXAnchor)
        summaryLabel.setHeight(13)
    }
    
    private func configureCreateTaskButton() {
        createTaskButton.setImage(UIImage(named: "List/SummaryView/createTask"), for: .normal)
        createTaskButton.tintColor = .SummaryView.createButton
        self.addSubview(createTaskButton)
        createTaskButton.pinRight(to: self.trailingAnchor)
        createTaskButton.pinTop(to: border.bottomAnchor, UIConstants.Spacing.createButtonTop)
        createTaskButton.setWidth(UIConstants.Sizing.createButtonWidth)
        createTaskButton.setHeight(UIConstants.Sizing.createButtonHeight)
        
        createTaskButton.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
    }
    
    // MARK: Actions
    @objc func createTaskButtonTapped() {
        onCreateTaskButtonTapped?()
    }

    // MARK: - Public API
    func setTasksCount(_ count: Int) {
        self.tasksCount = count
        summaryLabel.text = "\(count) \(tasksWord(for: count))"
    }

    // MARK: - Helpers
    private func tasksWord(for count: Int) -> String {
        let lastTwo = count % 100
        if lastTwo >= 11 && lastTwo <= 14 { return "задач" }
        switch count % 10 {
        case 1: return "задача"
        case 2, 3, 4: return "задачи"
        default: return "задач"
        }
    }
}
