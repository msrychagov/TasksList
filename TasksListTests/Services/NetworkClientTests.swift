import XCTest
@testable import TasksList

final class NetworkClientTests: XCTestCase {
	func test_request_buildsCorrectURL_forTodos() {
		let session = URLProtocolStub.makeSession()
		let sut = NetworkService.createForTesting(with: session)
		let url = URL(string: "https://dummyjson.com/todos")!
		let payload = "{\"todos\":[],\"total\":0,\"skip\":0,\"limit\":0}".data(using: .utf8)!
		URLProtocolStub.stubs[url] = .init(data: payload, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), error: nil)
		let exp = expectation(description: "fetch")
		sut.fetchTodos { result in
			if case .success(let resp) = result { XCTAssertEqual(resp.todos.count, 0) } else { XCTFail("expected success") }
			exp.fulfill()
		}
		wait(for: [exp], timeout: 1)
	}
}
