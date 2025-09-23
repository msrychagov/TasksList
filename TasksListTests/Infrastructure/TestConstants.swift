//
//  TestConstants.swift
//  TasksListTests
//

import Foundation

enum TestConstants {
    enum Timeout {
        static let short: TimeInterval = 1
        static let medium: TimeInterval = 2
        static let long: TimeInterval = 3
        static let veryLong: TimeInterval = 5
        static let ultra: TimeInterval = 10
    }

    enum Delay {
        static let veryShort: TimeInterval = 0.01
        static let short: TimeInterval = 0.02
        static let shorter: TimeInterval = 0.03
        static let medium: TimeInterval = 0.05
        static let long: TimeInterval = 0.1
        static let veryLong: TimeInterval = 0.2
    }

    enum DateSeconds {
        static let epoch: TimeInterval = 0
        static let oneDay: TimeInterval = 86400
        static let sample100: TimeInterval = 100
        static let sample200: TimeInterval = 200
    }

    enum Semaphore {
        static let wait: DispatchTimeInterval = .seconds(1)
    }
}


