import Foundation

final class URLProtocolStub: URLProtocol {
	struct Stub {
		let data: Data?
		let response: URLResponse?
		let error: Error?
	}
	static var stubs: [URL: Stub] = [:]

	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

	override class func canInit(with task: URLSessionTask) -> Bool {
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

	override func startLoading() {
		let url = request.url ?? (task?.currentRequest?.url)
		guard let url, let stub = URLProtocolStub.stubs[url] else {
			client?.urlProtocol(self, didFailWithError: URLError(.badURL))
			client?.urlProtocolDidFinishLoading(self)
			return
		}
		if let response = stub.response {
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		}
		if let data = stub.data {
			client?.urlProtocol(self, didLoad: data)
		}
		if let error = stub.error {
			client?.urlProtocol(self, didFailWithError: error)
		} else {
			client?.urlProtocolDidFinishLoading(self)
		}
	}

	override func stopLoading() {}

	static func makeSession() -> URLSession {
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [URLProtocolStub.self]
		return URLSession(configuration: config)
	}
}
