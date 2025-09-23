//
//  TasksService.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

import Foundation

// MARK: - Tasks Service Protocol
protocol TasksServiceProtocol {
    func loadInitialTasks(completion: @escaping (Result<[TaskItem], Error>) -> Void)
}

// MARK: - Tasks Service Implementation
final class TasksService: TasksServiceProtocol {
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    func loadInitialTasks(completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        networkService.fetchTodos { result in
            switch result {
            case .success(let todosResponse):
                let taskItems = todosResponse.todos.toDomainModels()
                completion(.success(taskItems))
                
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}

// MARK: - Network Error Extension
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
