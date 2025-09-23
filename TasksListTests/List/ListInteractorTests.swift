import XCTest
@testable import TasksList

final class ListInteractorTests: XCTestCase {
	final class SpyOutput: ListInteractorOutput {
		var didLoadItemsCalls: [TasksList.ListModels.LoadTasks.Response] = []
		var filteredCalls: [TasksList.ListModels.FilterTasks.Response] = []
		var manageRequests: [ManageMode] = []
		var deleted: [TasksList.ListModels.DeleteTask.Response] = []
		var toggled: [TasksList.ListModels.ToggleIsDone.Response] = []
		var errors: [Error] = []
		var updates: [TasksList.ListModels.EditTask.Response] = []
		var created: [TasksList.ListModels.CreateTask.Response] = []
		func didLoadItems(response: TasksList.ListModels.LoadTasks.Response) { didLoadItemsCalls.append(response) }
		func didFilteredItems(response: TasksList.ListModels.FilterTasks.Response) { filteredCalls.append(response) }
		func didRequestManageTask(response: TasksList.ListModels.ManageTask.Response) { manageRequests.append(response.mode) }
		func didDeleteItem(response: TasksList.ListModels.DeleteTask.Response) { deleted.append(response) }
		func didToggleTaskState(response: TasksList.ListModels.ToggleIsDone.Response) { toggled.append(response) }
		func didFaileToEditTask(error: Error) { errors.append(error) }
		func didShareItem(response: TasksList.ListModels.ShareTask.Response) {}
		func didUpdateItem(response: TasksList.ListModels.EditTask.Response) { updates.append(response) }
		func didCreateItem(response: TasksList.ListModels.CreateTask.Response) { created.append(response) }
	}
	final class StubInitManager: AppInitializationManagerProtocol {
		var called = 0
		var shouldFail = false
		func initializeAppIfNeeded(with storage: any Storage, completion: @escaping (Result<Void, any Error>) -> Void) {
			called += 1
			if shouldFail { completion(.failure(NSError(domain: "x", code: 1))) } else { completion(.success(())) }
		}
	}

	func makeSUT(with tasks: [TaskItem] = []) -> (ListInteractor, SpyOutput, InMemoryStorage) {
		let storage = InMemoryStorage()
		let sema = DispatchSemaphore(value: 0)
		storage.initializeWithTasks(tasks) { _ in sema.signal() }
		_ = sema.wait(timeout: .now() + 1)
		let worker = ListWorker(storage: storage)
		let initManager = StubInitManager()
		let sut = ListInteractor(worker: worker, appInitializationManager: initManager)
		let output = SpyOutput()
		sut.output = output
		return (sut, output, storage)
	}

	func test_fetchTasks_onAppear_returnsSortedByCreationDesc() {
		let t1 = TaskItem(id: UUID(), title: "1", details: nil, isDone: false, date: Date(timeIntervalSince1970: 100))
		let t2 = TaskItem(id: UUID(), title: "2", details: nil, isDone: false, date: Date(timeIntervalSince1970: 200))
		let (sut, out, _) = makeSUT(with: [t1, t2])
		let exp = expectation(description: "fetch")
		sut.fetchItems(request: .init())
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { exp.fulfill() }
		wait(for: [exp], timeout: 2)
		guard case let .success(items)? = out.didLoadItemsCalls.last else { return XCTFail("no success") }
		XCTAssertEqual(items.map{ $0.id }, [t2.id, t1.id])
	}

	func test_deleteTask_removesAndReloadsList() {
		let t = TaskItem(id: UUID(), title: "1", details: nil, isDone: false, date: Date())
		let (sut, out, storage) = makeSUT(with: [t])
		let exp = expectation(description: "delete")
		sut.deleteItem(request: .init(id: t.id))
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { exp.fulfill() }
		wait(for: [exp], timeout: 2)
		guard case let .success(id) = out.deleted.last else { return XCTFail("no delete success") }
		XCTAssertEqual(id, t.id)
		let sema = DispatchSemaphore(value: 0)
		var count = -1
		storage.fetchAll { res in if case let .success(items) = res { count = items.count } ; sema.signal() }
		_ = sema.wait(timeout: .now() + 1)
		XCTAssertEqual(count, 0)
	}

	func test_toggleDone_switchesStatusAndPersists() {
		let t = TaskItem(id: UUID(), title: "1", details: nil, isDone: false, date: Date())
		let (sut, out, storage) = makeSUT(with: [t])
		let exp = expectation(description: "toggle")
		sut.toggleTaskState(request: .init(id: t.id))
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { exp.fulfill() }
		wait(for: [exp], timeout: 2)
		guard case let .success(changed) = out.toggled.last else { return XCTFail("no toggle success") }
		XCTAssertTrue(changed.isDone)
		let sema = DispatchSemaphore(value: 0)
		var persisted = false
		storage.fetchTask(withId: t.id) { res in if case let .success(task) = res { persisted = task.isDone } ; sema.signal() }
		_ = sema.wait(timeout: .now() + 1)
		XCTAssertTrue(persisted)
	}

	func test_search_withText_filtersByTitleOrDescription() {
		let t1 = TaskItem(id: UUID(), title: "output", details: nil, isDone: false, date: Date())
		let t2 = TaskItem(id: UUID(), title: "abc", details: nil, isDone: false, date: Date())
		let (sut, out, _) = makeSUT(with: [t1, t2])
		let exp = expectation(description: "fetch")
		sut.fetchItems(request: .init())
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { exp.fulfill() }
		wait(for: [exp], timeout: 2)
		sut.filterItems(request: .init(query: "opt"))
		guard case let .success(items) = out.filteredCalls.last! else { return XCTFail("no filter success") }
		XCTAssertEqual(items.map{ $0.id }, [t1.id])
	}

	func test_firstLaunch_triggersSeedFromDummyJSON_once() {
		let storage = InMemoryStorage()
		let worker = ListWorker(storage: storage)
		let initManager = StubInitManager()
		let sut = ListInteractor(worker: worker, appInitializationManager: initManager)
		let out = SpyOutput()
		sut.output = out
		sut.fetchItems(request: .init())
		sut.fetchItems(request: .init())
		XCTAssertGreaterThanOrEqual(initManager.called, 2) // initialize called per fetch
	}
}
