import XCTest
import UIKit
@testable import TasksList

final class ListRouterTests: XCTestCase {
	final class SpyVC: UIViewController {
		var presented: UIViewController?
		override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
			presented = viewControllerToPresent
			completion?()
		}
	}

	func test_routeToCreate_pushesManageTaskScreen() {
		let router = ListRouter()
		let root = SpyVC()
		let nav = UINavigationController(rootViewController: root)
		router.viewController = root
		router.routeToManageTaskView(mode: .create)
		XCTAssertEqual(nav.viewControllers.count, 2)
	}

	func test_routeToEdit_pushesManageTaskScreen_withTaskID() {
		let router = ListRouter()
		let root = SpyVC()
		let nav = UINavigationController(rootViewController: root)
		router.viewController = root
		let id = UUID()
		router.routeToManageTaskView(mode: .edit(id))
		XCTAssertEqual(nav.viewControllers.count, 2)
	}

	func test_routeToShare_presentsActivityVC() {
		let router = ListRouter()
		let root = SpyVC()
		router.viewController = root
		router.routeToShare(with: "text")
		XCTAssertTrue(root.presented is UIActivityViewController)
	}
}
