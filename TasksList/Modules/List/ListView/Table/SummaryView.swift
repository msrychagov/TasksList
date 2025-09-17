//
//  BottomBarView.swift
//  TasksList
//
//  Created by Михаил Рычагов on 17.09.2025.
//

import UIKit

final class SummaryView: UIView {
    // MARK: - Properties
    private let tasksCount: Int
    
    // MARK: -
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
        border.setHeight(0.33)
        border.pinHorizontal(to: self)
    }
    
    private func configureSummaryLabel() {
        summaryLabel.text = "\(tasksCount) задач"
        summaryLabel.font = .systemFont(ofSize: 11, weight: .regular)
        summaryLabel.tintColor = .SummaryView.text
        self.addSubview(summaryLabel)
        summaryLabel.pinTop(to: border.bottomAnchor, 20)
        summaryLabel.pinBottom(to: self.bottomAnchor, 34)
        summaryLabel.pinCenterX(to: self.centerXAnchor)
    }
    
    private func configureCreateTaskButton() {
        createTaskButton.setImage(UIImage(named: "List/SummaryView/createTask"), for: .normal)
        createTaskButton.tintColor = .SummaryView.createButton
        self.addSubview(createTaskButton)
        createTaskButton.pinRight(to: self.trailingAnchor)
        createTaskButton.pinTop(to: border.bottomAnchor, 13)
        createTaskButton.setWidth(68)
        createTaskButton.setHeight(28)
    }
}
