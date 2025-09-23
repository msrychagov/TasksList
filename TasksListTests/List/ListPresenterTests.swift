import XCTest
@testable import TasksList

final class ListPresenterTests: XCTestCase {
	final class SpyView: ListViewInput {
		var shownVMs: [ListModels.LoadTasks.ViewModel] = []
		var removed: [UUID] = []
		var reloaded: [ListModels.EditTask.ViewModel] = []
		var inserted: [ListModels.ListItemViewModel] = []
		var emptyShown = false
		var lastOnMain = false
		func show(viewModel: TasksList.ListModels.LoadTasks.ViewModel) { lastOnMain = Thread.isMainThread; shownVMs.append(viewModel) }
		func removeItem(viewModel: TasksList.ListModels.DeleteTask.ViewModel) { lastOnMain = Thread.isMainThread; removed.append(viewModel.id) }
		func reloadItem(viewModel: TasksList.ListModels.EditTask.ViewModel) { lastOnMain = Thread.isMainThread; reloaded.append(viewModel) }
		func insertItem(viewModel: TasksList.ListModels.ListItemViewModel) { lastOnMain = Thread.isMainThread; inserted.append(viewModel) }
		func showEmpty() { lastOnMain = Thread.isMainThread; emptyShown = true }
		func showPopup(for id: UUID) {}
		func showIsLoading() {}
		func showError() {}
	}
	final class StubRouter: ListRouterInput { func routeToManageTaskView(mode: ManageMode) {} ; func routeToShare(with text: String) {} }
	final class StubInteractor: ListInteractorInput {
		var output: ListInteractorOutput?
		func filterItems(request: TasksList.ListModels.FilterTasks.Request) {}
		func fetchItems(request: TasksList.ListModels.LoadTasks.Request) {}
		func createTask(request: TasksList.ListModels.ManageTask.Request) {}
		func deleteItem(request: TasksList.ListModels.DeleteTask.Request) {}
		func editTask(request: TasksList.ListModels.ManageTask.Request) {}
		func toggleTaskState(request: TasksList.ListModels.ToggleIsDone.Request) {}
		func shareItem(request: TasksList.ListModels.ShareTask.Request) {}
	}

	func makeSUT() -> (ListPresenter, SpyView) {
		let interactor = StubInteractor()
		let router = StubRouter()
		let presenter = ListPresenter(interactor: interactor, router: router)
		let view = SpyView()
		presenter.view = view
		return (presenter, view)
	}

	func test_presentTasks_mapsDomainToViewModels() {
		let (sut, view) = makeSUT()
		let items: [TaskItem] = [
			.init(id: UUID(), title: "A", details: "d", isDone: true, date: Date(timeIntervalSince1970: TestConstants.DateSeconds.epoch)),
			.init(id: UUID(), title: "B", details: nil, isDone: false, date: Date(timeIntervalSince1970: TestConstants.DateSeconds.oneDay))
		]
		sut.didLoadItems(response: .success(items))
		let exp = expectation(description: "map")
		DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.Delay.medium) { exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.short)
		XCTAssertEqual(view.shownVMs.count, 1)
		XCTAssertEqual(view.shownVMs.first?.items.count, 2)
		XCTAssertEqual(view.shownVMs.first?.items[0].title, "A")
		XCTAssertEqual(view.shownVMs.first?.items[0].subTitle, "d")
		XCTAssertEqual(view.shownVMs.first?.items[0].date, Date(timeIntervalSince1970: TestConstants.DateSeconds.epoch).dmyslash())
	}

	func test_presentEmpty_showsEmptyState() {
		let (sut, view) = makeSUT()
		sut.didFilteredItems(response: .empty)
		let exp = expectation(description: "empty")
		DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.Delay.short) { exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.short)
		XCTAssertTrue(view.emptyShown)
		XCTAssertEqual(view.shownVMs.last?.items.count, 0)
	}

	func test_presentToggle_reloadOnMain() {
		let (sut, view) = makeSUT()
		let task = TaskItem(id: UUID(), title: "T", details: nil, isDone: false, date: Date())
		sut.didToggleTaskState(response: .success(task))
		let exp = expectation(description: "reload")
		DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.Delay.medium) { exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.short)
		XCTAssertEqual(view.reloaded.count, 1)
		XCTAssertTrue(view.lastOnMain)
	}

	func test_callbacks_deliveredOnMainThread() {
		let (sut, view) = makeSUT()
		sut.didFilteredItems(response: .empty)
		let exp = expectation(description: "main")
		DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.Delay.shorter) { exp.fulfill() }
		wait(for: [exp], timeout: TestConstants.Timeout.short)
		XCTAssertTrue(view.lastOnMain)
	}
}
