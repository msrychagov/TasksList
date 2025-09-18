//
//  DateToString.swift
//  TasksList
//
//  Created by Михаил Рычагов on 18.09.2025.
//

import Foundation

extension Date {
    func dmyslash() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
}
