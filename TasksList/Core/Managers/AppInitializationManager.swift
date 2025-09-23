//
//  AppInitializationManager.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

// MARK: - App Initialization Manager Protocol
protocol AppInitializationManagerProtocol {
    func initializeAppIfNeeded(with storage: Storage, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - App Initialization Manager Implementation
final class AppInitializationManager: AppInitializationManagerProtocol {
    
    // MARK: - Properties
    private let tasksService: TasksServiceProtocol
    private let userDefaults: UserDefaults
    
    // MARK: - Constants
    private enum Keys {
        static let hasInitializedData = "hasInitializedData"
    }
    
    // MARK: - Initialization
    init(tasksService: TasksServiceProtocol = TasksService(), userDefaults: UserDefaults = .standard) {
        self.tasksService = tasksService
        self.userDefaults = userDefaults
    }
    
    // MARK: - Public Methods
    func initializeAppIfNeeded(with storage: Storage, completion: @escaping (Result<Void, Error>) -> Void) {
        if userDefaults.bool(forKey: Keys.hasInitializedData) {
            completion(.success(()))
            return
        }
        
        storage.fetchAll { [weak self] result in
            switch result {
            case .success(let tasks):
                if tasks.isEmpty {
                    self?.loadInitialDataFromAPI(storage: storage, completion: completion)
                } else {
                    self?.markAsInitialized()
                    completion(.success(()))
                }
            case .failure:
                self?.loadInitialDataFromAPI(storage: storage, completion: completion)
            }
        }
    }
    
    // MARK: - Private Methods
    private func loadInitialDataFromAPI(storage: Storage, completion: @escaping (Result<Void, Error>) -> Void) {
        tasksService.loadInitialTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                storage.initializeWithTasks(tasks) { initResult in
                    switch initResult {
                    case .success:
                        self?.markAsInitialized()
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func markAsInitialized() {
        userDefaults.set(true, forKey: Keys.hasInitializedData)
    }
    
    func resetInitializationFlag() {
        userDefaults.removeObject(forKey: Keys.hasInitializedData)
    }
}
