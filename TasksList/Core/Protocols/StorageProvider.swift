//
//  StorageProvider.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

// MARK: - Storage Provider Protocol

protocol StorageProvider {
    func getStorage() -> Storage
}
