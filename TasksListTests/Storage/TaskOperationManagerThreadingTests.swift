import XCTest
@testable import TasksList

final class TaskOperationManagerThreadingTests: XCTestCase {
	func makeSUT() -> (CoreDataStorage, CoreDataStack) {
		let stack = CoreDataStack(inMemory: true)
		let storage = CoreDataStorage(coreDataStack: stack)
		return (storage, stack)
	}

	func test_operationsExecuteAsynchronously_andDoNotBlockMain() {
		let (storage, _) = makeSUT()
		var completed = false
		storage.createTask(title: "A", details: nil) { _ in completed = true }
		XCTAssertFalse(completed, "Completion should be async, not sync on call site")
		let exp = expectation(description: "async")
		DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.Delay.long) { exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.short)
		XCTAssertTrue(completed)
	}

	func test_completionDeliveredOnMainByContract() {
		let (storage, _) = makeSUT()
		let exp = expectation(description: "fetch")
		var onMain = false
		storage.fetchAll { _ in onMain = Thread.isMainThread; exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.medium)
		XCTAssertTrue(onMain)
	}

	func test_performance_fetchLargeDataset_underThreshold() {
		let (storage, _) = makeSUT()
		let createExp = expectation(description: "bulk")
		var tasks: [TaskItem] = (0..<1500).map { i in TaskItem(id: UUID(), title: "T\\(i)", details: nil, isDone: false, date: Date()) }
		storage.createTasks(tasks) { _ in createExp.fulfill() }
		wait(for: [createExp], timeout: TestConstants.Timeout.ultra)
		measure(metrics: [XCTClockMetric()]) {
			let exp = expectation(description: "fetch")
			storage.fetchAll { res in exp.fulfill() }
			wait(for: [exp], timeout: TestConstants.Timeout.veryLong)
		}
	}
}
