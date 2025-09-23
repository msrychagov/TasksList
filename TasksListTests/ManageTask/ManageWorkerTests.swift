import XCTest
@testable import TasksList

final class ManageWorkerTests: XCTestCase {
	func makeSUT() -> (ManageTaskWorker, CoreDataStorage) {
		let storage = CoreDataStorage(coreDataStack: CoreDataStack(inMemory: true))
		let worker = ManageTaskWorker(storage: storage)
		return (worker, storage)
	}

	func test_create_persistsAndReturnsID() {
		let (sut, storage) = makeSUT()
		let exp = expectation(description: "create")
		sut.createTask(title: "T", details: "D") { res in if case .success = res {} else { XCTFail() } ; exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.medium)
		let fetch = expectation(description: "fetch")
		var items: [TaskItem] = []
		storage.fetchAll { res in if case let .success(arr) = res { items = arr } ; fetch.fulfill() }
		wait(for: [fetch], timeout: TestConstants.Timeout.medium)
		XCTAssertEqual(items.count, 1)
	}

	func test_update_persistsChanges() {
		let (sut, storage) = makeSUT()
		let create = expectation(description: "create")
		var id: UUID!
		storage.createTask(title: "A", details: "d") { res in create.fulfill() }
		wait(for: [create], timeout: TestConstants.Timeout.medium)
		let fetch = expectation(description: "fetch")
		storage.fetchAll { res in if case let .success(arr) = res { id = arr.first?.id } ; fetch.fulfill() }
		wait(for: [fetch], timeout: TestConstants.Timeout.medium)
		let update = expectation(description: "update")
		sut.updateTask(with: id, title: "B", details: "e") { res in if case .success = res {} else { XCTFail() } ; update.fulfill() }
		wait(for: [update], timeout: TestConstants.Timeout.medium)
		let fetchOne = expectation(description: "fetch one")
		var task: TaskItem?
		storage.fetchTask(withId: id) { res in if case let .success(t) = res { task = t } ; fetchOne.fulfill() }
		wait(for: [fetchOne], timeout: TestConstants.Timeout.medium)
		XCTAssertEqual(task?.title, "B")
	}

	func test_loadByID_returnsExactEntity() {
		let (sut, storage) = makeSUT()
		let create = expectation(description: "create")
		var id: UUID!
		storage.createTask(title: "A", details: "d") { _ in create.fulfill() }
		wait(for: [create], timeout: TestConstants.Timeout.medium)
		let fetch = expectation(description: "fetch")
		storage.fetchAll { res in if case let .success(arr) = res { id = arr.first?.id } ; fetch.fulfill() }
		wait(for: [fetch], timeout: TestConstants.Timeout.medium)
		let load = expectation(description: "load")
		sut.loadTaskInfo(for: id) { res in if case let .success(t) = res { XCTAssertEqual(t.id, id) } else { XCTFail() } ; load.fulfill() }
		wait(for: [load], timeout: TestConstants.Timeout.medium)
	}

	func test_update_nonExisting_throws() {
		let (sut, _) = makeSUT()
		let exp = expectation(description: "update")
		sut.updateTask(with: UUID(), title: "B", details: "e") { res in if case .success = res { XCTFail() } ; exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.medium)
	}
}
