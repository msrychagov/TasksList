//
//  EmptyView.swift
//  TasksList
//
//  Created by Михаил Рычагов on 18.09.2025.
//

import UIKit

final class EmptySearchResultView: UIView {
    // MARK: - UI Properties
    private var stackView: UIStackView = UIStackView()
    private var titleLabel: UILabel = UILabel()
    private var subtitleLabel: UILabel = UILabel()
    private var image: UIImageView = UIImageView()
    
    // MARK: - Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureUI
    private func configureUI() {
        configureStackView()
        configureImage()
        configureTitleLabel()
        configureSubtitleLabel()
    }
    
    private func configureImage() {
        image.image = UIImage(systemName: "magnifyingglass")
        image.tintColor = .systemGray
        stackView.addArrangedSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setHeight(56)
        image.setWidth(56)
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Нет результатов по запросу"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .General.secondary
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(12, after: titleLabel)
    }
    
    private func configureSubtitleLabel() {
        subtitleLabel.text = "Проверьте написание или попробуйте изменить запрос"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        self.addSubview(stackView)
        stackView.pinCenterX(to: self)
        stackView.pinCenterY(to: self)
        stackView.pinLeft(to: self, 24)
        stackView.pinRight(to: self, 24)
    }
}
