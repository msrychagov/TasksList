import XCTest
@testable import TasksList

final class ManageInteractorTests: XCTestCase {
	final class SpyOutput: ManageTaskInteractorOutput {
		var createCalls = 0
		var loadedTask: TaskItem?
		var loadError: Error?
		var updatedTitle: String?
		var updatedDesc: String?
		func didStartCreate(response: TasksList.ManageTaskModels.Create.Response) { createCalls += 1 }
		func didLoadTaskInfo(response: TasksList.ManageTaskModels.ShowInfo.Response) { loadedTask = response.task }
		func didFailToLoadTaskInfo(error: any Error) { loadError = error }
		func didUpdateTitle(response: TasksList.ManageTaskModels.UpdateTitle.Response) { updatedTitle = response.text }
		func didUpdateDescription(response: TasksList.ManageTaskModels.UpdateDescription.Response) { updatedDesc = response.text }
	}
	final class StubWorker: ManageTaskWorkerInput {
		var store: [UUID: TaskItem] = [:]
		func loadTaskInfo(for id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void) { if let t = store[id] { completion(.success(t)) } else { completion(.failure(StorageError.taskNotFound)) } }
		func createTask(title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) { completion(.success(())) }
		func updateTask(with id: UUID, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) { completion(.success(())) }
	}
	final class SpyWorker: ManageTaskWorkerInput {
		var created: [(String,String)] = []
		var updated: [(UUID,String,String)] = []
		var store: [UUID: TaskItem] = [:]
		func loadTaskInfo(for id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void) { if let t = store[id] { completion(.success(t)) } else { completion(.failure(StorageError.taskNotFound)) } }
		func createTask(title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) { created.append((title,details)); completion(.success(())) }
		func updateTask(with id: UUID, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) { updated.append((id,title,details)); completion(.success(())) }
	}

	func test_loadForCreate_modeIsCreate_andEmptyDraft() {
		let worker = StubWorker()
		let sut = ManageTaskInteractor(worker: worker, mode: .create)
		let out = SpyOutput()
		sut.output = out
		sut.loadTaskInfo(request: .init())
		XCTAssertEqual(out.createCalls, 1)
	}

	func test_loadForEdit_fetchesExistingTaskByID() {
		let id = UUID()
		let worker = StubWorker()
		worker.store[id] = TaskItem(id: id, title: "T", details: "D", isDone: false, date: Date())
		let sut = ManageTaskInteractor(worker: worker, mode: .edit(id))
		let out = SpyOutput()
		sut.output = out
		sut.loadTaskInfo(request: .init())
		XCTAssertEqual(out.loadedTask?.id, id)
	}

	func test_save_inCreateMode_persistsNewTask() {
		let worker = SpyWorker()
		let sut = ManageTaskInteractor(worker: worker, mode: .create)
		sut.saveTaskInfo(request: .init(title: "New title", details: "desc"))
		XCTAssertEqual(worker.created.count, 1)
		XCTAssertEqual(worker.created.first?.0, "New title")
	}

	func test_save_inEditMode_updatesExistingTask() {
		let id = UUID()
		let worker = SpyWorker()
		let sut = ManageTaskInteractor(worker: worker, mode: .edit(id))
		sut.saveTaskInfo(request: .init(title: "Edited", details: "desc"))
		XCTAssertEqual(worker.updated.count, 1)
		XCTAssertEqual(worker.updated.first?.0, id)
		XCTAssertEqual(worker.updated.first?.1, "Edited")
	}

	func test_validation_rejectsEmptyTitle() {
		let worker = StubWorker()
		let sut = ManageTaskInteractor(worker: worker, mode: .create)
		let out = SpyOutput(); sut.output = out
		sut.saveTaskInfo(request: .init(title: "", details: ""))
		XCTAssertNil(out.loadError)
	}
}
