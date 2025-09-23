//
//  CoreDataStorageUsageExample.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

// MARK: - Пример использования CoreDataStorage

/**
 Примеры использования CoreDataStorage с операциями на фоновом потоке
 */
class CoreDataStorageUsageExample {
    
    private let storage = CoreDataStorage.shared
    
    // MARK: - Примеры базовых операций
    
    func createTaskExample() {
        storage.createTask(title: "Новая задача", details: "Описание задачи") { result in
            switch result {
            case .success():
                print("✅ Задача успешно создана")
            case .failure(let error):
                print("❌ Ошибка создания задачи: \(error)")
            }
        }
    }
    
    func fetchAllTasksExample() {
        storage.fetchAll { result in
            switch result {
            case .success(let tasks):
                print("✅ Получено \(tasks.count) задач")
                tasks.forEach { task in
                    print("- \(task.title): \(task.isDone ? "✅" : "⏳")")
                }
            case .failure(let error):
                print("❌ Ошибка получения задач: \(error)")
            }
        }
    }
    
    func updateTaskExample(taskId: UUID) {
        storage.updateTask(
            with: taskId,
            title: "Обновленная задача",
            details: "Новое описание"
        ) { result in
            switch result {
            case .success():
                print("✅ Задача успешно обновлена")
            case .failure(let error):
                print("❌ Ошибка обновления задачи: \(error)")
            }
        }
    }
    
    func deleteTaskExample(taskId: UUID) {
        storage.delete(taskId) { result in
            switch result {
            case .success():
                print("✅ Задача успешно удалена")
            case .failure(let error):
                print("❌ Ошибка удаления задачи: \(error)")
            }
        }
    }
    
    // MARK: - Примеры дополнительных операций
    
    func toggleTaskStatusExample(taskId: UUID) {
        storage.toggleTaskStatus(withId: taskId) { result in
            switch result {
            case .success():
                print("✅ Статус задачи переключен")
            case .failure(let error):
                print("❌ Ошибка переключения статуса: \(error)")
            }
        }
    }
    
    func getTasksCountExample() {
        storage.getTasksCount { result in
            switch result {
            case .success(let count):
                print("📊 Всего задач: \(count)")
            case .failure(let error):
                print("❌ Ошибка подсчета задач: \(error)")
            }
        }
    }
    
    func fetchCompletedTasksExample() {
        storage.fetchCompletedTasks { result in
            switch result {
            case .success(let tasks):
                print("✅ Получено \(tasks.count) выполненных задач")
            case .failure(let error):
                print("❌ Ошибка получения выполненных задач: \(error)")
            }
        }
    }
    
    func searchTasksExample() {
        storage.searchTasks(searchText: "важная") { result in
            switch result {
            case .success(let tasks):
                print("🔍 Найдено \(tasks.count) задач по запросу 'важная'")
            case .failure(let error):
                print("❌ Ошибка поиска задач: \(error)")
            }
        }
    }
    
    // MARK: - Пример массовых операций
    
    func createMultipleTasksExample() {
        let tasks = [
            TaskItem(id: UUID(), title: "Задача 1", details: "Описание 1", isDone: false, date: Date()),
            TaskItem(id: UUID(), title: "Задача 2", details: "Описание 2", isDone: false, date: Date()),
            TaskItem(id: UUID(), title: "Задача 3", details: "Описание 3", isDone: false, date: Date())
        ]
        
        storage.createTasks(tasks) { result in
            switch result {
            case .success():
                print("✅ Множественные задачи успешно созданы")
            case .failure(let error):
                print("❌ Ошибка создания множественных задач: \(error)")
            }
        }
    }
    
    // MARK: - Пример управления очередями
    
    func queueManagementExample() {
        // Приостановить операции записи
        storage.suspendWriteOperations()
        print("⏸ Операции записи приостановлены")
        
        // Возобновить через 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.storage.resumeWriteOperations()
            print("▶️ Операции записи возобновлены")
        }
    }
    
    // MARK: - Пример с обработкой уведомлений
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            forName: TasksEvents.taskDidCreate,
            object: nil,
            queue: .main
        ) { notification in
            if let payload = notification.userInfo?["newTask"] as? TasksEvents.CreatePayload {
                print("🔔 Получено уведомление о создании задачи: \(payload.task.title)")
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: TasksEvents.taskDidChange,
            object: nil,
            queue: .main
        ) { notification in
            if let payload = notification.userInfo?["changedTask"] as? TasksEvents.UpdatedPayload {
                print("🔔 Получено уведомление об изменении задачи с ID: \(payload.id)")
            }
        }
    }
    
    // MARK: - Полный пример рабочего процесса
    
    func completeWorkflowExample() {
        print("🚀 Начинаем полный рабочий процесс с CoreDataStorage")
        
        // 1. Подписываемся на уведомления
        subscribeToNotifications()
        
        // 2. Создаем задачу
        storage.createTask(title: "Тестовая задача", details: "Для демонстрации") { result in
            switch result {
            case .success():
                print("✅ Шаг 1: Задача создана")
                
                // 3. Получаем все задачи
                self.storage.fetchAll { result in
                    switch result {
                    case .success(let tasks):
                        print("✅ Шаг 2: Получено \(tasks.count) задач")
                        
                        guard let firstTask = tasks.first else { return }
                        
                        // 4. Обновляем задачу
                        self.storage.updateTask(
                            with: firstTask.id,
                            title: "Обновленная тестовая задача",
                            details: "Обновленное описание"
                        ) { result in
                            switch result {
                            case .success():
                                print("✅ Шаг 3: Задача обновлена")
                                
                                // 5. Переключаем статус
                                self.storage.toggleTaskStatus(withId: firstTask.id) { result in
                                    switch result {
                                    case .success():
                                        print("✅ Шаг 4: Статус переключен")
                                        
                                        // 6. Получаем статистику
                                        self.storage.getTasksCount { result in
                                            if case .success(let count) = result {
                                                print("✅ Шаг 5: Итого задач - \(count)")
                                                print("🎉 Рабочий процесс завершен успешно!")
                                            }
                                        }
                                        
                                    case .failure(let error):
                                        print("❌ Ошибка на шаге 4: \(error)")
                                    }
                                }
                                
                            case .failure(let error):
                                print("❌ Ошибка на шаге 3: \(error)")
                            }
                        }
                        
                    case .failure(let error):
                        print("❌ Ошибка на шаге 2: \(error)")
                    }
                }
                
            case .failure(let error):
                print("❌ Ошибка на шаге 1: \(error)")
            }
        }
    }
}
