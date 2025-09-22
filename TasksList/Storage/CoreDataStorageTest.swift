//
//  CoreDataStorageTest.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import Foundation

class CoreDataStorageTest {
    
    static func testBasicOperations() {
        print("🧪 Начинаем тестирование CoreDataStorage...")
        
        let storage = CoreDataStorage.shared
        
        // Тест 1: Создание задачи
        print("📝 Тест 1: Создание задачи")
        storage.createTask(title: "Тестовая задача", details: "Описание для теста") { result in
            switch result {
            case .success():
                print("✅ Задача успешно создана")
                
                // Тест 2: Получение всех задач
                print("📋 Тест 2: Получение всех задач")
                storage.fetchAll { result in
                    switch result {
                    case .success(let tasks):
                        print("✅ Получено \(tasks.count) задач")
                        
                        if let firstTask = tasks.first {
                            print("📄 Первая задача: \(firstTask.title)")
                            
                            // Тест 3: Обновление задачи
                            print("✏️ Тест 3: Обновление задачи")
                            storage.updateTask(
                                with: firstTask.id,
                                title: "Обновленная задача",
                                details: "Обновленное описание"
                            ) { result in
                                switch result {
                                case .success():
                                    print("✅ Задача успешно обновлена")
                                    
                                    // Тест 4: Переключение статуса
                                    print("🔄 Тест 4: Переключение статуса")
                                    storage.toggleTaskStatus(withId: firstTask.id) { result in
                                        switch result {
                                        case .success():
                                            print("✅ Статус успешно переключен")
                                            
                                            // Тест 5: Получение статистики
                                            print("📊 Тест 5: Получение статистики")
                                            storage.getTasksCount { result in
                                                switch result {
                                                case .success(let count):
                                                    print("✅ Всего задач: \(count)")
                                                    print("🎉 Все тесты прошли успешно!")
                                                case .failure(let error):
                                                    print("❌ Ошибка получения статистики: \(error)")
                                                }
                                            }
                                            
                                        case .failure(let error):
                                            print("❌ Ошибка переключения статуса: \(error)")
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("❌ Ошибка обновления задачи: \(error)")
                                }
                            }
                        }
                        
                    case .failure(let error):
                        print("❌ Ошибка получения задач: \(error)")
                    }
                }
                
            case .failure(let error):
                print("❌ Ошибка создания задачи: \(error)")
            }
        }
    }
    
    static func testInMemoryStorage() {
        print("🧪 Тестирование in-memory хранилища...")
        
        // Создаем временное хранилище для тестов
        let inMemoryStack = CoreDataStack(inMemory: true)
        let storage = CoreDataStorage(coreDataStack: inMemoryStack)
        
        storage.createTask(title: "In-Memory задача", details: nil) { result in
            switch result {
            case .success():
                print("✅ In-Memory задача создана")
                
                storage.fetchAll { result in
                    switch result {
                    case .success(let tasks):
                        print("✅ In-Memory: получено \(tasks.count) задач")
                    case .failure(let error):
                        print("❌ In-Memory ошибка: \(error)")
                    }
                }
                
            case .failure(let error):
                print("❌ In-Memory ошибка создания: \(error)")
            }
        }
    }
}
