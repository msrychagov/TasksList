//
//  UIColor+ColorLibrary.swift
//  TasksList
//
//  Created by Михаил Рычагов on 17.09.2025.
//

import UIKit

extension UIColor {
    enum General {
        static let secondary: UIColor = UIColor.adaptiveColor(lightHex: "040404", darkHex: "F4F4F4")
        static let primary: UIColor = UIColor.adaptiveColor(lightHex: "#F4F4F4", darkHex: "#040404")
    }
    enum DoneButton {
        static let normal: UIColor = UIColor.adaptiveColor(lightHex: "#FED702", darkHex: "#FED702")
        static let selected: UIColor = UIColor.adaptiveColor(lightHex: "#FED702", darkHex: "#FED702")
    }
    enum SearchBar {
        static let background: UIColor = UIColor.adaptiveColor(lightHex: "#F5F5F5", darkHex: "#272729")
        static let tintColor: UIColor = UIColor.secondaryLabel
    }
    enum SummaryView {
        static let background: UIColor = UIColor.adaptiveColor(lightHex: "#F6F6F6", darkHex: "#272729")
        static let border: UIColor = UIColor.adaptiveColor(lightHex: "#E0E0E0", darkHex: "#A0A0A0")
        static let text: UIColor = UIColor.adaptiveColor(lightHex: "#040404", darkHex: "#F4F4F4")
        static let createButton: UIColor = UIColor.adaptiveColor(lightHex: "#FED702", darkHex: "#FED702")
    }
}
