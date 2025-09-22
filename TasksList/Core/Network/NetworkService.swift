//
//  NetworkService.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

// MARK: - Network Errors

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
}

// MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<TodosResponse, NetworkError>) -> Void)
}

// MARK: - Network Service Implementation

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL = "https://dummyjson.com"
    private let localJSONPath = "/Users/mixail.rychagov/Downloads/todos.json"
    
    // MARK: - Initialization
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    
    /// Загружает список задач из DummyJSON API с fallback на локальный файл
    func fetchTodos(completion: @escaping (Result<TodosResponse, NetworkError>) -> Void) {
        // Сначала пробуем загрузить с API
        fetchTodosFromAPI { [weak self] result in
            switch result {
            case .success(let todosResponse):
                completion(.success(todosResponse))
            case .failure:
                // В случае неудачи, пробуем загрузить с локального файла
                print("API недоступен, загружаем из локального файла...")
                self?.fetchTodosFromLocalFile(completion: completion)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Загружает задачи из DummyJSON API
    private func fetchTodosFromAPI(completion: @escaping (Result<TodosResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/todos") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            // Обрабатываем ошибки сети
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Проверяем наличие данных
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Декодируем JSON
            do {
                let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: data)
                completion(.success(todosResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    /// Загружает задачи из локального JSON файла
    private func fetchTodosFromLocalFile(completion: @escaping (Result<TodosResponse, NetworkError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: self.localJSONPath))
                let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todosResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    if error is DecodingError {
                        completion(.failure(.decodingError(error)))
                    } else {
                        completion(.failure(.networkError(error)))
                    }
                }
            }
        }
    }
}

// MARK: - Network Service Extensions

extension NetworkService {
    
    /// Создает экземпляр сервиса для тестирования с кастомной сессией
    static func createForTesting(with session: URLSession) -> NetworkService {
        return NetworkService(session: session)
    }
}
