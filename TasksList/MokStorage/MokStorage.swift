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
}
final class InMemoryStorage: Storage {
    func delete(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async {
            guard let idx = self.tasks.firstIndex(where: { $0.id == id }) else {
                completion(.failure(StorageError.deleteError))
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
        TaskItem(id: UUID(), title: "ababccc", description: "aa", isDone: true, date: Date()),
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
