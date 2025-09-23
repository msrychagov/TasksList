//
//  StorageProvider.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

// MARK: - Storage Provider Protocol

/// Протокол для объектов, которые предоставляют доступ к хранилищу данных
protocol StorageProvider {
    func getStorage() -> Storage
}
