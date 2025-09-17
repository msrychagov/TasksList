//
//  MokStorage.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//
import Foundation

protocol Storage {
    func fetchAll(completion: @escaping (Result<[TaskItem], Error>) -> Void)
}
final class InMemoryStorage: Storage {
    func fetchAll(completion: @escaping (Result<[TaskItem], any Error>) -> Void) {
        queue.async {
            completion(.success(self.tasks))
        }
    }
    
    static var shared = InMemoryStorage()
    private let tasks: [TaskItem] = [
        TaskItem(id: UUID(), title: "a", description: "aa", isDone: true, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bbмраимрвоамиваромиваравлоиваолрмивалмиыавивлаоимваломиваломивалоомваромиваморваимровамивфримромирывоимрло", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "bвывыавымывмыовмтлыомлыовмтвыломвыолмтыво", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", description: "bb", isDone: false, date: Date())
    ]
    private let queue = DispatchQueue(label: "inMemoryTasksStorageQueue", qos: .userInteractive, attributes: .concurrent)
}
