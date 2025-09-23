# CoreDataStorage - Реализация хранилища через CoreData

Полная реализация хранилища для задач с использованием CoreData, GCD и NSOperation для выполнения операций на фоновом потоке.

## Архитектура

### Основные компоненты:

1. **`CDTaskItem`** - NSManagedObject модель для CoreData
2. **`TaskOperations.swift`** - NSOperation классы для CRUD операций
3. **`TaskOperationManager`** - Менеджер очередей и операций
4. **`CoreDataStorage`** - Основной класс, реализующий протокол Storage
5. **`CoreDataStack`** - Существующий стек CoreData

## Особенности реализации

### 🔄 Многопоточность
- **Операции чтения**: выполняются на concurrent очереди (до 3 одновременных операций)
- **Операции записи**: выполняются на serial очереди (по одной операции за раз)
- **GCD очередь**: для быстрых операций без CoreData
- **Все callback'и**: возвращаются на главный поток

### 📱 Уведомления
Автоматическая отправка уведомлений через NotificationCenter:
- `TasksEvents.taskDidCreate` - при создании задачи
- `TasksEvents.taskDidChange` - при изменении задачи

### 🛡️ Безопасность потоков
- Каждая операция использует собственный background context
- `performAndWait` для синхронного выполнения в контексте
- Merge policy настроен для автоматического разрешения конфликтов

## Использование

### Основные операции

```swift
let storage = CoreDataStorage.shared

// Создание задачи
storage.createTask(title: "Новая задача", description: "Описание") { result in
    switch result {
    case .success():
        print("Задача создана")
    case .failure(let error):
        print("Ошибка: \(error)")
    }
}

// Получение всех задач
storage.fetchAll { result in
    switch result {
    case .success(let tasks):
        print("Получено \(tasks.count) задач")
    case .failure(let error):
        print("Ошибка: \(error)")
    }
}

// Обновление задачи
storage.updateTask(with: taskId, title: "Новый заголовок", description: "Новое описание") { result in
    // handle result
}

// Удаление задачи
storage.delete(taskId) { result in
    // handle result
}
```

### Дополнительные возможности

```swift
// Переключение статуса задачи
storage.toggleTaskStatus(withId: taskId) { result in
    // handle result
}

// Поиск задач
storage.searchTasks(searchText: "важная") { result in
    // handle result
}

// Получение только выполненных задач
storage.fetchCompletedTasks { result in
    // handle result
}

// Получение статистики
storage.getTasksCount { result in
    // handle result
}
```

### Массовые операции

```swift
// Создание нескольких задач за одну транзакцию
let tasks = [
    TaskItem(id: UUID(), title: "Задача 1", description: nil, isDone: false, date: Date()),
    TaskItem(id: UUID(), title: "Задача 2", description: nil, isDone: false, date: Date())
]

storage.createTasks(tasks) { result in
    // handle result
}

// Удаление всех задач
storage.deleteAllTasks { result in
    // handle result
}
```

### Управление очередями

```swift
// Приостановка операций записи (например, при низком заряде батареи)
storage.suspendWriteOperations()

// Возобновление операций
storage.resumeWriteOperations()

// Отмена всех операций записи
storage.cancelWriteOperations()

// Ожидание завершения всех операций (для тестирования)
storage.waitForCompletion()
```

## Структура файлов

```
Storage/
├── CDTaskItem.swift                    # CoreData модель
├── CoreDataStack.swift                 # Существующий стек CoreData
├── CoreDataStorage.swift               # Основная реализация Storage
├── TaskOperations.swift               # NSOperation классы для CRUD
├── TaskOperationManager.swift         # Менеджер операций и очередей
├── StorageError.swift                 # Типы ошибок
└── CoreDataStorageUsageExample.swift  # Примеры использования
```

## Типы операций NSOperation

### 1. `CreateTaskOperation`
- Создание новой задачи
- Автоматическая отправка уведомления `taskDidCreate`

### 2. `FetchAllTasksOperation`
- Получение всех задач
- Конвертация CoreData объектов в доменные модели

### 3. `FetchTaskOperation`
- Получение конкретной задачи по ID
- Обработка случая "задача не найдена"

### 4. `UpdateTaskOperation`
- Обновление существующей задачи
- Отправка уведомления `taskDidChange`

### 5. `DeleteTaskOperation`
- Удаление задачи по ID
- Безопасная обработка несуществующих задач

### 6. `ToggleTaskStatusOperation`
- Переключение статуса isDone
- Отправка уведомления об изменении

## Обработка ошибок

```swift
enum StorageError: Error {
    case deleteError          // Ошибка удаления
    case taskNotFound         // Задача не найдена
    case coreDataError(Error) // Ошибка CoreData
    case contextNotAvailable  // Контекст недоступен
    case saveError           // Ошибка сохранения
    case fetchError          // Ошибка получения данных
}
```

## Подписка на уведомления

```swift
// Подписка на создание задач
NotificationCenter.default.addObserver(
    forName: TasksEvents.taskDidCreate,
    object: nil,
    queue: .main
) { notification in
    if let payload = notification.userInfo?["newTask"] as? TasksEvents.CreatePayload {
        print("Создана задача: \(payload.task.title)")
    }
}

// Подписка на изменение задач
NotificationCenter.default.addObserver(
    forName: TasksEvents.taskDidChange,
    object: nil,
    queue: .main
) { notification in
    if let payload = notification.userInfo?["changedTask"] as? TasksEvents.UpdatedPayload {
        print("Изменена задача с ID: \(payload.id)")
    }
}
```

## Преимущества данной реализации

### ✅ Многопоточность
- Все операции с CoreData выполняются на фоновых потоках
- Разделение операций чтения и записи на разные очереди
- Возможность контроля количества одновременных операций

### ✅ Масштабируемость  
- Легко добавить новые типы операций
- Возможность настройки приоритетов операций
- Поддержка массовых операций

### ✅ Надежность
- Автоматическое разрешение конфликтов
- Обработка всех типов ошибок
- Безопасность потоков

### ✅ Удобство использования
- Простой API, соответствующий существующему протоколу Storage
- Автоматические уведомления
- Дополнительные convenience методы

### ✅ Производительность
- Использование batch операций для массовых действий
- Оптимизированные NSFetchRequest с предикатами
- Возможность приостановки/возобновления операций

## Настройка CoreData модели

Для использования необходимо создать CoreData модель (.xcdatamodeld) с entity "CDTaskItem":

**Атрибуты:**
- `id`: UUID, обязательный
- `title`: String, обязательный  
- `taskDescription`: String, опциональный
- `isDone`: Boolean, по умолчанию NO
- `date`: Date, обязательный

## Миграция с InMemoryStorage

Для перехода с существующего `InMemoryStorage` на `CoreDataStorage`:

```swift
// Старый способ
let storage = InMemoryStorage.shared

// Новый способ  
let storage = CoreDataStorage.shared

// API остается тем же, никаких изменений в коде не требуется!
```

## Тестирование

Для юнит-тестов можно использовать in-memory CoreData:

```swift
let coreDataStack = CoreDataStack(inMemory: true)
let storage = CoreDataStorage(coreDataStack: coreDataStack)
```

Это создаст временное хранилище в памяти, которое не сохраняется на диск.

---

Данная реализация обеспечивает высокую производительность, надежность и удобство использования при работе с задачами в многопоточной среде.
