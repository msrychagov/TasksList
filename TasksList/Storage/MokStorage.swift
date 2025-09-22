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
    func initializeWithTasks(_ tasks: [TaskItem], completion: @escaping (Result<Void, Error>) -> Void)
}
final class InMemoryStorage: Storage {
    func createTask(title: String, details: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        queue.async {
            let newTask = TaskItem(
                id: UUID(),
                title: title,
                details: details,
                isDone: false,
                date: Date()
            )
            self.tasks.append(newTask)
            
            NotificationCenter.default.post(
                name: TasksEvents.taskDidCreate,
                object: self,
                userInfo: ["newTask": TasksEvents.CreatePayload(task: newTask)]
            )
        }
    }
    
    func updateTask(with id: UUID, title: String, details: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        queue.async {
            if let idx = self.tasks.firstIndex(where: { $0.id == id }) {
                let prevTask = self.tasks[idx]
                self.tasks[idx] = TaskItem(
                    id: id,
                    title: title,
                    details: details,
                    isDone: prevTask.isDone,
                    date: prevTask.date
                )
                
                NotificationCenter.default.post(
                    name: TasksEvents.taskDidChange,
                    object: self,
                    userInfo: ["changedTask": TasksEvents.UpdatedPayload(id: id)]
                )
            }
        }
    }
    
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
    
    func initializeWithTasks(_ tasks: [TaskItem], completion: @escaping (Result<Void, any Error>) -> Void) {
        queue.async(flags: .barrier) {
            // Очищаем существующие задачи и заменяем их новыми
            self.tasks = tasks
            completion(.success(()))
        }
    }
    
    static var shared = InMemoryStorage()
    private var tasks: [TaskItem] = [
        TaskItem(id: UUID(), title: "ababccc", details: "", isDone: true, date: Date()),
        TaskItem(id: UUID(), title: "b", details: "bbмраимрвоамиваромиваравлоиваолрмивалмиыавивлаоимваломиваломивалоомваромиваморваимровамивфримромирывоимрло", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "bвывыавымывмыовмтлыомлыовмтвыломвыолмтыво", details: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "carabct", details: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", details: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", details: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", details: "bb", isDone: false, date: Date()),
        TaskItem(id: UUID(), title: "b", details: "bb", isDone: false, date: Date())
    ]
    private let queue = DispatchQueue(label: "inMemoryTasksStorageQueue", qos: .userInteractive, attributes: .concurrent)
}
