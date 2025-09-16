//
//  DoneButton.swift
//  TasksList
//
//  Created by Михаил Рычагов on 16.09.2025.
//

import UIKit

final class DoneButton: UIButton {
    // MARK: - Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configure() {
        setImage(UIImage(systemName: "circle"), for: .normal)
        setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        
        addTarget(self, action: #selector(toggleSelected), for: .touchUpInside)
    }
    
    // MARK: - Action
    @objc
    private func toggleSelected() {
        isSelected.toggle()
    }
}
