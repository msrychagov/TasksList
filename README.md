# TasksList - iOS приложение для управления задачами

Приложение для создания и управления списком задач с использованием архитектуры VIPER, CoreData и многопоточности.

## 📱 Функциональность

### Основные возможности:
- ✅ **Список задач** - отображение всех задач на главном экране с возможностью прокрутки
- ✅ **Создание задач** - добавление новых задач с названием и описанием через модальное окно
- ✅ **Редактирование** - изменение существующих задач с сохранением изменений
- ✅ **Удаление** - удаление ненужных задач с подтверждением
- ✅ **Поиск** - поиск задач по названию и описанию с фильтрацией в реальном времени
- ✅ **Статус задач** - отметка о выполнении/невыполнении с визуальной индикацией
- ✅ **Дата создания** - автоматическое добавление даты создания и отображение
- ✅ **Шаринг** - возможность поделиться задачей через системные сервисы

### Дополнительные возможности:
- 🔄 **Автосохранение** - автоматическое сохранение при выходе с экрана редактирования
- 🌐 **Офлайн режим** - работа без интернета с локальными данными
- 🎨 **Адаптивный дизайн** - поддержка светлой и темной тем
- 📱 **Responsive UI** - адаптация под разные размеры экранов
- ⌨️ **Keyboard handling** - корректная работа с клавиатурой

## 🏗️ Архитектура VIPER

Приложение построено с использованием архитектуры VIPER с четким разделением ответственности:

### Принципы VIPER:
- **View** - отображает данные и передает пользовательские действия
- **Interactor** - содержит бизнес-логику и работает с данными
- **Presenter** - обрабатывает данные от Interactor и подготавливает их для View
- **Entity** - модели данных предметной области
- **Router** - управляет навигацией между модулями

### Модули приложения:

#### 1. **List Module** - Главный экран со списком задач
- **ListViewController** - основной экран со списком задач
- **ListPresenter** - обработка бизнес-логики отображения
- **ListInteractor** - работа с данными и бизнес-правила
- **ListRouter** - навигация к экрану редактирования
- **ListWorker** - работа с хранилищем данных
- **ListTableAdapter** - управление таблицей с использованием DiffableDataSource

#### 2. **ManageTask Module** - Создание и редактирование задач
- **ManageTaskHostingVC** - хостинг-контроллер для SwiftUI
- **ManageTaskView** - SwiftUI интерфейс для редактирования
- **ManageTaskPresenter** - обработка логики редактирования
- **ManageTaskInteractor** - бизнес-логика создания/редактирования
- **ManageTaskRouter** - навигация обратно к списку
- **ManageTaskWorker** - работа с хранилищем

## 🛠️ Технологии и паттерны

### Основные технологии:
- **Swift 5.9+** - основной язык разработки
- **iOS 15.0+** - минимальная поддерживаемая версия
- **UIKit** - для основных экранов и навигации
- **SwiftUI** - для экрана редактирования задач
- **CoreData** - локальное хранение данных
- **URLSession** - сетевые запросы к API

### Архитектурные паттерны:
- **VIPER** - основная архитектура приложения
- **MVVM** - для SwiftUI компонентов
- **Repository Pattern** - абстракция работы с данными
- **Dependency Injection** - внедрение зависимостей через инициализаторы
- **Observer Pattern** - через NotificationCenter для уведомлений
- **Factory Pattern** - для создания модулей через Assembly

### Многопоточность:
- **GCD (Grand Central Dispatch)** - для асинхронных операций
- **NSOperation** - для сложных фоновых задач с зависимостями
- **DispatchQueue** - управление очередями выполнения
- **Background Context** - для CoreData операций в фоне

## 📁 Детальная структура проекта

```
TasksList/
├── App/                          # Конфигурация приложения
│   ├── AppDelegate.swift         # Точка входа приложения
│   └── SceneDelegate.swift       # Управление сценами
├── Core/                         # Основные компоненты
│   ├── Domain/                   # Модели предметной области
│   │   └── TaskItem.swift        # Основная модель задачи
│   ├── Events/                   # Система событий
│   │   └── TasksEvents.swift     # Уведомления о изменениях
│   ├── Managers/                 # Менеджеры приложения
│   │   └── AppInitializationManager.swift # Инициализация данных
│   ├── Network/                  # Сетевой слой
│   │   ├── NetworkService.swift  # HTTP клиент
│   │   └── Models/
│   │       └── TodoDTO.swift     # DTO для API
│   └── Protocols/                # Протоколы
│       └── StorageProvider.swift # Абстракция хранилища
├── Modules/                      # Модули VIPER
│   ├── List/                     # Список задач
│   │   ├── ListAssembly.swift    # Фабрика модуля
│   │   ├── ListProtocols.swift   # Протоколы модуля
│   │   ├── ListInteractor/       # Бизнес-логика
│   │   ├── ListPresenter/        # Презентационная логика
│   │   ├── ListRouter/           # Навигация
│   │   ├── ListView/             # UI компоненты
│   │   ├── ListModels/           # Модели данных
│   │   └── ListWorker.swift      # Работа с данными
│   └── ManageTask/               # Создание/редактирование
│       ├── ManageTaskAssembly.swift
│       ├── ManageTaskProtocols.swift
│       ├── ManageTaskInteractor/
│       ├── ManageTaskPresenter/
│       ├── ManageTaskRouter/
│       ├── ManageTaskView/
│       ├── ManageTaskModels/
│       └── ManageTaskWorker.swift
├── Services/                     # Сервисы
│   └── TasksService.swift        # Сервис работы с задачами
├── Storage/                      # Слой данных
│   ├── CoreDataStack.swift       # Конфигурация CoreData
│   ├── CoreDataStorage.swift     # Реализация хранилища
│   ├── TaskOperations.swift      # NSOperation для CRUD
│   ├── TaskOperationManager.swift # Менеджер операций
│   ├── ToDoAdapter.swift         # Адаптер для CoreData
│   └── StorageError.swift        # Ошибки хранилища
├── Utils/                        # Утилиты
│   ├── ColorConstants.swift      # Цветовая схема
│   ├── UIConstants.swift         # UI константы
│   ├── AppConstants.swift        # Константы приложения
│   └── Extensions/               # Расширения
│       ├── Date/
│       └── String/
└── Resources/                    # Ресурсы
    └── todos.json                # Локальные данные для fallback
```

## 🔄 Детальные потоки данных

### Создание новой задачи:
1. **Пользователь** нажимает кнопку "+" в SummaryView
2. **ListViewController** → **ListPresenter** → **ListRouter**
3. **ListRouter** создает **ManageTaskModule** через **ManageTaskAssembly**
4. **ManageTaskHostingVC** отображает **ManageTaskView**
5. **Пользователь** вводит данные и выходит с экрана
6. **ManageTaskHostingVC** → **ManageTaskPresenter** → **ManageTaskInteractor**
7. **ManageTaskInteractor** → **ManageTaskWorker** → **CoreDataStorage**
8. **CoreDataStorage** выполняет операцию в фоне через **TaskOperationManager**
9. **Уведомление** отправляется через **NotificationCenter**
10. **ListViewController** получает уведомление и обновляет список

### Загрузка задач при запуске:
1. **AppDelegate** → **SceneDelegate** → **ListAssembly**
2. **ListViewController** → **ListPresenter** → **ListInteractor**
3. **ListInteractor** → **AppInitializationManager**
4. **AppInitializationManager** → **TasksService** → **NetworkService**
5. **NetworkService** пытается загрузить с API, при ошибке → локальный файл
6. **TasksService** → **CoreDataStorage** для сохранения
7. **CoreDataStorage** → **TaskOperationManager** → фоновые операции
8. **ListInteractor** → **ListPresenter** → **ListViewController**
9. **ListViewController** отображает загруженные задачи

### Поиск задач:
1. **Пользователь** вводит текст в SearchBar
2. **ListViewController** → **ListPresenter** → **ListInteractor**
3. **ListInteractor** → **ListWorker** → **CoreDataStorage**
4. **CoreDataStorage** выполняет поиск в фоне
5. **Результаты** возвращаются через цепочку обратно
6. **ListViewController** обновляет таблицу с результатами

## 🧪 Детальное тестирование

### Структура тестов:
```
TasksListTests/
├── List/                         # Тесты модуля списка
│   ├── ListPresenterTests.swift  # Тесты презентера
│   ├── ListInteractorTests.swift # Тесты интерактора
│   ├── ListAdapterTests.swift    # Тесты адаптера таблицы
│   └── ListInteractorErrorAndThreadingTests.swift # Тесты ошибок и потоков
├── ManageTask/                   # Тесты модуля редактирования
│   ├── ManagePresenterTests.swift
│   ├── ManageInteractorTests.swift
│   └── ManageWorkerTests.swift
├── Storage/                      # Тесты хранилища
│   ├── CoreDataStorageTests.swift
│   └── TaskOperationManagerThreadingTests.swift
├── Services/                     # Тесты сервисов
│   ├── NetworkClientTests.swift
│   └── FirstLaunchSeedTests.swift
├── Router/                       # Тесты роутера
│   └── ListRouterTests.swift
├── Utils/                        # Тесты утилит
│   ├── DateFormatterTests.swift
│   └── FuzzySearchTests.swift
└── Infrastructure/               # Инфраструктура тестов
    ├── InMemoryCoreDataStackTests.swift
    ├── URLProtocolStub.swift
    └── TestQueues.swift
```

### Покрытие тестами:
- **Unit тесты** - тестирование отдельных компонентов в изоляции
- **Integration тесты** - тестирование взаимодействия между модулями
- **Threading тесты** - проверка корректности многопоточности
- **Error handling тесты** - тестирование обработки ошибок
- **Mock тесты** - использование заглушек для внешних зависимостей

## 🎨 UI/UX дизайн

### Дизайн-система:
- **Минималистичный интерфейс** - чистый и понятный дизайн
- **Адаптивные цвета** - автоматическое переключение между темами
- **Плавные анимации** - использование DiffableDataSource для анимаций
- **Accessibility** - поддержка VoiceOver и других функций доступности
- **Responsive layout** - адаптация под разные размеры экранов

### Цветовая схема:
```swift
// Светлая тема
primaryBackground: #FFFFFF
primaryText: #040404
brandYellow: #B8860B (темный для контраста)

// Темная тема  
primaryBackground: #040404
primaryText: #FFFFFF
brandYellow: #FED702 (светлый для контраста)
```

### Компоненты UI:
- **ListTaskCell** - ячейка задачи с кнопкой выполнения
- **SummaryView** - нижняя панель с счетчиком и кнопкой создания
- **EmptySearchResultView** - экран пустого поиска
- **TightTextEditor** - кастомный текстовый редактор
- **DoneButton** - кнопка выполнения задачи

## 🚀 Запуск и настройка проекта

### Системные требования:
- **Xcode 15.0+** - среда разработки
- **iOS 15.0+** - минимальная версия ОС
- **Swift 5.9+** - версия языка
- **macOS 13.0+** - для разработки

### Установка и запуск:
1. **Клонирование репозитория:**
   ```bash
   git clone <repository-url>
   cd TasksList
   ```

2. **Открытие проекта:**
   ```bash
   open TasksList.xcodeproj
   ```

3. **Настройка симулятора:**
   - Выбрать iPhone 15 Pro или новее
   - iOS 17.0+ для лучшей производительности

4. **Запуск приложения:**
   - Нажать ⌘+R или кнопку "Run"
   - Приложение автоматически загрузит данные

### Первый запуск:
- **API загрузка** - приложение попытается загрузить данные с dummyjson.com
- **Fallback данные** - при отсутствии интернета загрузит локальный todos.json
- **CoreData инициализация** - создаст локальное хранилище
- **UI настройка** - применит текущую тему системы

## 📊 Производительность и оптимизации

### Оптимизации производительности:
- **Фоновые операции** - все CRUD операции выполняются в фоне
- **Кэширование** - данные кэшируются в CoreData
- **Lazy loading** - ленивая загрузка компонентов UI
- **Memory management** - правильное управление памятью с weak references
- **DiffableDataSource** - эффективные обновления таблицы
- **Background context** - отдельные контексты для фоновых операций

### Мониторинг производительности:
- **Instruments** - профилирование с помощью Xcode Instruments
- **Memory leaks** - отслеживание утечек памяти
- **Thread safety** - проверка безопасности многопоточности
- **Core Data** - мониторинг производительности хранилища
- **Network** - отслеживание сетевых запросов

### Метрики производительности:
- **Время запуска** - < 2 секунд до отображения списка
- **Время отклика** - < 100ms для операций CRUD
- **Использование памяти** - < 50MB в обычном режиме
- **Потребление батареи** - оптимизировано для фоновых операций

## 🔧 Конфигурация и настройки

### Настройка API:
```swift
// NetworkService.swift
private let baseURL = "https://dummyjson.com"
private let todosEndpoint = "/todos"
```

### Настройка CoreData:
```swift
// CoreDataStack.swift
container = NSPersistentContainer(name: "TasksList")
// Автоматическая миграция включена
```

### Настройка цветов:
```swift
// ColorConstants.swift
static let brandYellow = (light: "#B8860B", dark: "#FED702")
```

### Настройка UI констант:
```swift
// UIConstants.swift
enum Spacing { /* отступы */ }
enum Sizing { /* размеры */ }
enum Fonts { /* шрифты */ }
```

## 🐛 Отладка и диагностика

### Логирование:
- **Print statements** - для отладки (удалены в продакшене)
- **Error handling** - детальная обработка ошибок
- **User feedback** - показ ошибок пользователю через алерты

### Инструменты отладки:
- **Xcode Debugger** - пошаговая отладка
- **Console logs** - просмотр логов в консоли
- **Network Inspector** - мониторинг сетевых запросов
- **Core Data Inspector** - просмотр данных в хранилище

## 📝 Лицензия и авторство

**Автор:** Михаил Рычагов  
**Дата создания:** Сентябрь 2025  
**Назначение:** Учебный проект для демонстрации современных подходов к iOS разработке

## 🎯 Заключение

Данное приложение демонстрирует:
- ✅ **Современную архитектуру** VIPER с четким разделением ответственности
- ✅ **Многопоточность** с использованием GCD и NSOperation
- ✅ **Локальное хранение** данных через CoreData
- ✅ **Сетевую интеграцию** с внешним API
- ✅ **Качественное тестирование** с хорошим покрытием
- ✅ **Адаптивный дизайн** для разных тем и устройств
- ✅ **Производительность** и оптимизацию

Проект готов к использованию и может служить основой для более сложных приложений управления задачами.

---

*Для получения дополнительной информации о конкретных компонентах см. соответствующие файлы в проекте.*
