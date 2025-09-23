//
//  MokStorage.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//
import Foundation

protocol Storage {
    func fetchAll(completion: @escaping (Result<[TaskItem], Error>) -> Void)
    func fetchTask(withId id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void)
    func delete(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func createTask(title: String, details: String?, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTask(with id: UUID, title: String, details: String?, completion: @escaping (Result<Void, Error>) -> Void)
    func toggleTaskStatus(withId id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func initializeWithTasks(_ tasks: [TaskItem], completion: @escaping (Result<Void, Error>) -> Void)
}
