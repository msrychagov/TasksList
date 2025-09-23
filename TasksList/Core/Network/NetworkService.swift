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
    
    // MARK: - Initialization
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    func fetchTodos(completion: @escaping (Result<TodosResponse, NetworkError>) -> Void) {
        fetchTodosFromAPI { [weak self] result in
            switch result {
            case .success(let todosResponse):
                DispatchQueue.main.async {
                    completion(.success(todosResponse))
                }
            case .failure:
                // В случае неудачи, пробуем загрузить с локального файла
                self?.fetchTodosFromLocalFile(completion: completion)
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchTodosFromAPI(completion: @escaping (Result<TodosResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/todos") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todosResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
    
    private func fetchTodosFromLocalFile(completion: @escaping (Result<TodosResponse, NetworkError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
                    DispatchQueue.main.async {
                        completion(.failure(.networkError(NSError(domain: "LocalFileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Local todos.json file not found in app bundle"]))))
                    }
                    return
                }
                
                let data = try Data(contentsOf: url)
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
    static func createForTesting(with session: URLSession) -> NetworkService {
        return NetworkService(session: session)
    }
}
