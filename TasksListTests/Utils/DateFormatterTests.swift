import XCTest
@testable import TasksList

final class DateFormatterTests: XCTestCase {
	func test_dmy_formatter_exactPattern() {
		let date = Date(timeIntervalSince1970: 0)
		XCTAssertEqual(date.dmyslash(), "01/01/70")
	}
}
