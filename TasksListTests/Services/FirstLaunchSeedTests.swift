import XCTest
@testable import TasksList

final class FirstLaunchSeedTests: XCTestCase {
	final class StubUserDefaults: UserDefaults {
		var store: [String: Any] = [:]
		override func bool(forKey defaultName: String) -> Bool { (store[defaultName] as? Bool) ?? false }
		override func set(_ value: Any?, forKey defaultName: String) { store[defaultName] = value }
		override func removeObject(forKey defaultName: String) { store.removeValue(forKey: defaultName) }
	}

	override func setUp() {
		super.setUp()
		URLProtocolStub.stubs.removeAll()
	}

	func test_import_parsesTodosPayload_correctly() {
		let session = URLProtocolStub.makeSession()
		let sut = NetworkService.createForTesting(with: session)
		let url = URL(string: "https://dummyjson.com/todos")!
		let json = "{" +
			"\"todos\":[{" +
			"\"id\":1,\"todo\":\"Buy milk\",\"completed\":true,\"userId\":99" +
			"}],\"total\":1,\"skip\":0,\"limit\":30}"
		URLProtocolStub.stubs[url] = .init(data: json.data(using: .utf8)!, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), error: nil)
		let exp = expectation(description: "map")
		sut.fetchTodos { result in
			guard case let .success(resp) = result else { return }
			let items = resp.todos.toDomainModels()
			XCTAssertEqual(items.count, 1)
			XCTAssertEqual(items[0].title, "Buy milk")
			XCTAssertTrue(items[0].isDone)
			exp.fulfill()
		}
		wait(for: [exp], timeout: TestConstants.Timeout.long)
	}

	func test_import_setsFirstLaunchFlag_and_idempotentOnSecondRun() {
		let ud = StubUserDefaults()
		let session = URLProtocolStub.makeSession()
		let network = NetworkService.createForTesting(with: session)
		let tasksService = TasksService(networkService: network)
		let manager = AppInitializationManager(tasksService: tasksService, userDefaults: ud)
		let storage = CoreDataStorage(coreDataStack: CoreDataStack(inMemory: true))
		let url = URL(string: "https://dummyjson.com/todos")!
		let json = "{\"todos\":[],\"total\":0,\"skip\":0,\"limit\":30}"
		URLProtocolStub.stubs[url] = .init(data: json.data(using: .utf8)!, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), error: nil)
		let exp1 = expectation(description: "first")
		manager.initializeAppIfNeeded(with: storage) { res in if case .success = res {} else { XCTFail() } ; exp1.fulfill() }
		wait(for: [exp1], timeout: TestConstants.Timeout.long)
		XCTAssertTrue(ud.bool(forKey: "hasInitializedData"))
		let exp2 = expectation(description: "second")
		manager.initializeAppIfNeeded(with: storage) { res in if case .success = res {} else { XCTFail() } ; exp2.fulfill() }
		wait(for: [exp2], timeout: TestConstants.Timeout.short)
	}
}
