import Foundation

final class TestQueues {
	let mainQueue: DispatchQueue
	let backgroundQueue: DispatchQueue
	let serialQueue: DispatchQueue
	init(label: String = "tests") {
		self.mainQueue = DispatchQueue.main
		self.backgroundQueue = DispatchQueue(label: "tests.bg.", qos: .userInitiated)
		self.serialQueue = DispatchQueue(label: "tests.serial.")
	}
}
