//
//  ExtensionsTests.swift
//  TasksList
//
//  Created by Михаил Рычагов on 18.09.2025.
//

import XCTest
@testable import TasksList

final class ExtensionsTests: XCTestCase {
    
    func testDateFormatter() {
        var comps = DateComponents()
        comps.calendar = Calendar(identifier: .gregorian)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        comps.year = 2025
        comps.month = 9
        comps.day = 18
        let date = comps.date
        let formattedDate = date?.dmyslash()
        let expectedFormattedDate = "18/09/25"
        XCTAssertEqual(formattedDate, expectedFormattedDate)
    }

}
