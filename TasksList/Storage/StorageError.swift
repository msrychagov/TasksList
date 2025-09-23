//
//  StorageError.swift
//  TasksList
//
//  Created by Михаил Рычагов on 18.09.2025.
//

enum StorageError: Error {
    case deleteError
    case taskNotFound
    case coreDataError(Error)
    case contextNotAvailable
    case saveError
    case fetchError
}
