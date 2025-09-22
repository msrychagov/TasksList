//
//  Color+Hex.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import SwiftUI

extension Color {
    init(uiColor: UIColor) {
        self.init(UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return uiColor
            default:
                return uiColor
            }
        })
    }

    static func adaptive(light: String, dark: String) -> Color {
        Color(uiColor: .adaptiveColor(lightHex: light, darkHex: dark))
    }

    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }

        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xFF0000) >> 16
        let green = (rgbValue & 0xFF00) >> 8
        let blue = rgbValue & 0xFF
        self.init(
            .sRGB,
            red: Double(red) / 0xFF,
            green: Double(green) / 0xFF,
            blue: Double(blue) / 0xFF,
            opacity: alpha
        )
    }
}
