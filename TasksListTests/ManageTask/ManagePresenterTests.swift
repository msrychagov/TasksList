import XCTest
@testable import TasksList

final class ManagePresenterTests: XCTestCase {
	final class SpyView: ManageTaskViewInput {
		var showedInfo: ManageTaskModels.ShowInfo.ViewModel?
		var updatedTitle: String?
		var updatedDescription: String?
		func setLoading(isLoading: Bool) {}
		func showTaskInfo(viewModel: TasksList.ManageTaskModels.ShowInfo.ViewModel) { showedInfo = viewModel }
		func showUpdatedTitle(viewModel: TasksList.ManageTaskModels.UpdateTitle.ViewModel) { updatedTitle = viewModel.text }
		func showUpdatedDescription(viewModel: TasksList.ManageTaskModels.UpdateDescription.ViewModel) { updatedDescription = viewModel.text }
	}
	final class StubRouter: ManageTaskRouterInput {}
	final class StubInteractor: ManageTaskInteractorInput {
		func loadTaskInfo(request: TasksList.ManageTaskModels.ShowInfo.Request) {}
		func saveTaskInfo(request: TasksList.ManageTaskModels.SaveTaskInfo.Request) {}
		func updateTitle(request: TasksList.ManageTaskModels.UpdateTitle.Request) {}
		func updateDescription(request: TasksList.ManageTaskModels.UpdateDescription.Request) {}
	}

	func test_presentInitialState_buildsFormViewModel() {
		let presenter = ManageTaskPresenter(interactor: StubInteractor(), router: StubRouter())
		let view = SpyView(); presenter.view = view
		let task = TaskItem(id: UUID(), title: "T", details: "D", isDone: false, date: Date(timeIntervalSince1970: 0))
		presenter.didLoadTaskInfo(response: .init(task: task))
		let exp = expectation(description: "map")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { exp.fulfill() }
		wait(for: [exp], timeout: 1)
		XCTAssertEqual(view.showedInfo?.info.title, "T")
		XCTAssertEqual(view.showedInfo?.info.note, "D")
		XCTAssertEqual(view.showedInfo?.info.date, "01/01/70")
	}

	func test_presentValidation_updatesSaveEnabled() {
		let presenter = ManageTaskPresenter(interactor: StubInteractor(), router: StubRouter())
		let view = SpyView(); presenter.view = view
		presenter.didUpdateTitle(response: .init(text: "Hello"))
		presenter.didUpdateDescription(response: .init(text: "World"))
		let exp = expectation(description: "main")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { exp.fulfill() }
		wait(for: [exp], timeout: 1)
		XCTAssertEqual(view.updatedTitle, "Hello")
		XCTAssertEqual(view.updatedDescription, "World")
	}
}
