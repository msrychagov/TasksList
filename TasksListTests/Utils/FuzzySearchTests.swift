import XCTest
@testable import TasksList

final class FuzzySearchTests: XCTestCase {
	func test_contains_subsequenceMatch_true() {
		XCTAssertTrue("output".contains("opt"))
	}
	func test_contains_noMatch_false() {
		XCTAssertFalse("swift".contains("abc"))
	}
	func test_matched_trueForDistanceLE2_orSubsequence() {
		XCTAssertTrue("kitten".matched(with: "sitten"))
		XCTAssertTrue("output".matched(with: "opt"))
	}
	func test_matched_falseForFarEdits() {
		XCTAssertFalse("abcdef".matched(with: "zzz"))
	}
}
