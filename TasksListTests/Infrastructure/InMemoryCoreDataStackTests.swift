import XCTest
import CoreData
@testable import TasksList

final class InMemoryCoreDataStackTests: XCTestCase {
	func test_inMemoryStack_createsAndSavesEntities() {
		let stack = CoreDataStack(inMemory: true)
		let context = stack.newBackgroundContext()
		context.performAndWait {
			let entity = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
			entity.setValue(UUID(), forKey: "id")
			entity.setValue("title", forKey: "title")
			entity.setValue(false, forKey: "done")
			entity.setValue(nil, forKey: "details")
			entity.setValue(Date(), forKey: "date")
			try? context.save()
		}
		let view = stack.viewContext
		let request = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
		let count = (try? view.count(for: request)) ?? -1
		XCTAssertEqual(count, 1)
	}
}
