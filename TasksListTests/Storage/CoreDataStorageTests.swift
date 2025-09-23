import XCTest
import CoreData
@testable import TasksList

final class CoreDataStorageTests: XCTestCase {
	func makeSUT() -> CoreDataStorage {
		let stack = CoreDataStack(inMemory: true)
		return CoreDataStorage(coreDataStack: stack)
	}

	func test_create_fetch_edit_delete_CRUD() {
		let sut = makeSUT()
		let create = expectation(description: "create")
		sut.createTask(title: "A", details: "d") { res in if case .success = res {} else { XCTFail() } ; create.fulfill() }
		wait(for: [create], timeout: 2)
		let fetch = expectation(description: "fetch all")
		var tasks: [TaskItem] = []
		sut.fetchAll { res in if case let .success(items) = res { tasks = items } else { XCTFail() } ; fetch.fulfill() }
		wait(for: [fetch], timeout: 2)
		XCTAssertEqual(tasks.count, 1)
		let id = tasks[0].id
		let update = expectation(description: "update")
		sut.updateTask(with: id, title: "B", details: "e") { res in if case .success = res {} else { XCTFail() } ; update.fulfill() }
		wait(for: [update], timeout: 2)
		let fetchOne = expectation(description: "fetch one")
		var one: TaskItem?
		sut.fetchTask(withId: id) { res in if case let .success(item) = res { one = item } ; fetchOne.fulfill() }
		wait(for: [fetchOne], timeout: 2)
		XCTAssertEqual(one?.title, "B")
		let del = expectation(description: "delete")
		sut.delete(id) { res in if case .success = res {} else { XCTFail() } ; del.fulfill() }
		wait(for: [del], timeout: 2)
		let fetchAfter = expectation(description: "fetch after")
		var count = -1
		sut.fetchAll { res in if case let .success(items) = res { count = items.count } ; fetchAfter.fulfill() }
		wait(for: [fetchAfter], timeout: 2)
		XCTAssertEqual(count, 0)
	}

	func test_fetch_sortedByCreationDesc() {
		let sut = makeSUT()
		let create1 = expectation(description: "c1"); let create2 = expectation(description: "c2")
		sut.createTask(title: "A", details: nil) { _ in create1.fulfill() }
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.01) { sut.createTask(title: "B", details: nil) { _ in create2.fulfill() } }
		wait(for: [create1, create2], timeout: 2)
		let fetch = expectation(description: "fetch")
		var tasks: [TaskItem] = []
		sut.fetchTasks(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) { res in if case let .success(items) = res { tasks = items } ; fetch.fulfill() }
		wait(for: [fetch], timeout: 2)
		XCTAssertGreaterThanOrEqual(tasks.count, 2)
		XCTAssertTrue(tasks[0].date >= tasks[1].date)
	}

	func test_search_predicateMatchesTitleOrDescription() {
		let sut = makeSUT()
		let create = expectation(description: "c")
		sut.createTask(title: "hello world", details: "note") { _ in create.fulfill() }
		wait(for: [create], timeout: 2)
		let fetch = expectation(description: "search")
		var tasks: [TaskItem] = []
		sut.searchTasks(searchText: "world") { res in if case let .success(items) = res { tasks = items } ; fetch.fulfill() }
		wait(for: [fetch], timeout: 2)
		XCTAssertEqual(tasks.count, 1)
	}
}
