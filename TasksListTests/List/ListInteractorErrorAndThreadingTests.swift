import XCTest
@testable import TasksList

final class ListInteractorErrorAndThreadingTests: XCTestCase {
	final class SpyOutput: ListInteractorOutput {
		var loaded: [TasksList.ListModels.LoadTasks.Response] = []
		var filtered: [TasksList.ListModels.FilterTasks.Response] = []
		var deletions: [TasksList.ListModels.DeleteTask.Response] = []
		var toggles: [TasksList.ListModels.ToggleIsDone.Response] = []
		var manage: [ManageMode] = []
		var updateOnMain = false
		func didLoadItems(response: TasksList.ListModels.LoadTasks.Response) { updateOnMain = Thread.isMainThread; loaded.append(response) }
		func didFilteredItems(response: TasksList.ListModels.FilterTasks.Response) { updateOnMain = Thread.isMainThread; filtered.append(response) }
		func didRequestManageTask(response: TasksList.ListModels.ManageTask.Response) { manage.append(response.mode) }
		func didDeleteItem(response: TasksList.ListModels.DeleteTask.Response) { updateOnMain = Thread.isMainThread; deletions.append(response) }
		func didToggleTaskState(response: TasksList.ListModels.ToggleIsDone.Response) { updateOnMain = Thread.isMainThread; toggles.append(response) }
		func didFaileToEditTask(error: Error) {}
		func didShareItem(response: TasksList.ListModels.ShareTask.Response) {}
		func didUpdateItem(response: TasksList.ListModels.EditTask.Response) { updateOnMain = Thread.isMainThread }
		func didCreateItem(response: TasksList.ListModels.CreateTask.Response) { updateOnMain = Thread.isMainThread }
	}
	final class FailingStorage: Storage {
		func fetchAll(completion: @escaping (Result<[TaskItem], Error>) -> Void) { DispatchQueue.global().async { completion(.failure(StorageError.fetchError)) } }
		func fetchTask(withId id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void) { completion(.failure(StorageError.taskNotFound)) }
		func delete(_ id: UUID, completion: @escaping (Result<Void, Error>) -> Void) { completion(.failure(StorageError.deleteError)) }
		func createTask(title: String, details: String?, completion: @escaping (Result<Void, Error>) -> Void) { completion(.failure(StorageError.saveError)) }
		func updateTask(with id: UUID, title: String, details: String?, completion: @escaping (Result<Void, Error>) -> Void) { completion(.failure(StorageError.saveError)) }
		func toggleTaskStatus(withId id: UUID, completion: @escaping (Result<Void, Error>) -> Void) { completion(.failure(StorageError.saveError)) }
		func initializeWithTasks(_ tasks: [TaskItem], completion: @escaping (Result<Void, Error>) -> Void) { completion(.failure(StorageError.saveError)) }
	}
	final class StubInitManager: AppInitializationManagerProtocol {
		func initializeAppIfNeeded(with storage: any Storage, completion: @escaping (Result<Void, any Error>) -> Void) { completion(.success(())) }
	}

	func test_fetch_failure_showsError() {
		let worker = ListWorker(storage: FailingStorage())
		let sut = ListInteractor(worker: worker, appInitializationManager: StubInitManager())
		let out = SpyOutput(); sut.output = out
		sut.fetchItems(request: .init())
		let exp = expectation(description: "err")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { exp.fulfill() }
		wait(for: [exp], timeout: 1)
		guard case .failure = out.loaded.last! else { return XCTFail("expected failure") }
	}

	func test_callbacks_deliveredOnMainThread() {
		let coreDataStorage = CoreDataStorage(coreDataStack: CoreDataStack(inMemory: true))
		let worker = ListWorker(storage: coreDataStorage)
		let sut = ListInteractor(worker: worker, appInitializationManager: StubInitManager())
		let out = SpyOutput(); sut.output = out
		sut.fetchItems(request: .init())
		let exp = expectation(description: "main")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { exp.fulfill() }
		wait(for: [exp], timeout: 1)
		XCTAssertTrue(out.updateOnMain)
	}
}
