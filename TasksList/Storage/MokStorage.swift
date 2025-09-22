//
//  MokStorage.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//
import Foundation

protocol Storage {
    func fetchAll(completion: @escaping (Result<[TaskItem], Error>) -> Void)
    func delete(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTask(withId id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void)
}
final class InMemoryStorage: Storage {
    func fetchTask(withId id: UUID, completion: @escaping (Result<TaskItem, any Error>) -> Void) {
        queue.async {
            guard let idx = self.tasks.firstIndex(where: { $0.id == id }) else {
                completion(.failure(StorageError.taskNotFound))
                return
            }
            completion(.success(self.tasks[idx]))
        }
    }
    
    func delete(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async {
            guard let idx = self.tasks.firstIndex(where: { $0.id == id }) else {
                completion(.failure(StorageError.taskNotFound))
                return
            }
            self.tasks.remove(at: idx)
            completion(.success(()))
        }
    }
    
    func fetchAll(completion: @escaping (Result<[TaskItem], any Error>) -> Void) {
        queue.async {
            completion(.success(self.tasks))
        }
    }
    
    static var shared = InMemoryStorage()
    private var tasks: [TaskItem] = [
        TaskItem(id: UUID(), title: "ababccc", description: "", isDone: true, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bbмраимрвоамиваромиваравлоиваолрмивалмиыавивлаоимваломиваломивалоомваромиваморваимровамивфримромирывоимрло", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "bвывыавымывмыовмтлыомлыовмтвыломвыолмтыво", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "carabct", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date())
    ]
    private let queue = DispatchQueue(label: "inMemoryTasksStorageQueue", qos: .userInteractive, attributes: .concurrent)
}
