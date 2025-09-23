//
//  ColorConstants.swift
//  TasksList
//
//  Centralized color constants for the entire application.
//  Provides unified color system for both UIKit and SwiftUI.
//

import UIKit
import SwiftUI

enum ColorConstants {
    
    // MARK: - Base Colors
    static let brandYellow = (light: "#E6B800", dark: "#FED702")
    
    // MARK: Text Colors
    static let primaryText = (light: "#040404", dark: "#FFFFFF")
    static let secondaryText = (light: "#040404", dark: "#F4F4F4")
    
    // MARK: Background Colors
    static let primaryBackground = (light: "#FFFFFF", dark: "#040404")
    static let secondaryBackground = (light: "#F5F5F5", dark: "#272729")
    static let tertiaryBackground = (light: "#DFDFDF", dark: "#272729")
    
    // MARK: UI Component Colors
    static let summaryViewBorder = (light: "#E0E0E0", dark: "#4D555E")
}

// MARK: - UIColor Extensions
extension UIColor {
    /// Creates adaptive UIColor from ColorConstants
    static func adaptiveColor(lightHex: String, darkHex: String) -> UIColor {
        return UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: darkHex)
            default:
                return UIColor(hex: lightHex)
            }
        }
    }
    
    /// Creates UIColor from hex string
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alphaFromHex, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alphaFromHex, red, green, blue) = (15, int >> 8, int >> 4 & 0xF, int & 0xF)
            self.init(red: CGFloat(red) / 15.0, green: CGFloat(green) / 15.0, blue: CGFloat(blue) / 15.0, alpha: alpha)
        case 6: // RGB (24-bit)
            (alphaFromHex, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            self.init(
                red: CGFloat(red) / 255.0,
                green: CGFloat(green) / 255.0,
                blue: CGFloat(blue) / 255.0,
                alpha: CGFloat(alphaFromHex)
            )
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
    }
    
    // MARK: - Structured Color Access
    enum General {
        static let primary: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.primaryBackground.light, darkHex: ColorConstants.primaryBackground.dark)
        static let secondary: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.primaryText.light, darkHex: ColorConstants.primaryText.dark)
    }
    
    enum SearchBar {
        static let background: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.secondaryBackground.light, darkHex: ColorConstants.secondaryBackground.dark)
        static let tintColor: UIColor = UIColor.secondaryLabel
    }
    
    enum SummaryView {
        static let background: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.tertiaryBackground.light, darkHex: ColorConstants.tertiaryBackground.dark)
        static let border: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.summaryViewBorder.light, darkHex: ColorConstants.summaryViewBorder.dark)
        static let text: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.primaryText.light, darkHex: ColorConstants.primaryText.dark)
        static let createButton: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.brandYellow.light, darkHex: ColorConstants.brandYellow.dark)
    }
    
    enum DoneButton {
        static let normal: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.brandYellow.light, darkHex: ColorConstants.brandYellow.dark)
        static let selected: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.brandYellow.light, darkHex: ColorConstants.brandYellow.dark)
    }
    
    enum Text {
        static let primary: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.primaryText.light, darkHex: ColorConstants.primaryText.dark)
        static let secondary: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.secondaryText.light, darkHex: ColorConstants.secondaryText.dark)
        static let date: UIColor = UIColor.systemGray
        static let completed: UIColor = UIColor.systemGray2
        static let completedSubtitle: UIColor = UIColor.systemGray3
    }
    
    enum Brand {
        static let yellow: UIColor = UIColor.adaptiveColor(lightHex: ColorConstants.brandYellow.light, darkHex: ColorConstants.brandYellow.dark)
    }
}

// MARK: - SwiftUI Color Extensions
extension Color {
    
    static func adaptive(light: String, dark: String) -> Color {
        Color(uiColor: .adaptiveColor(lightHex: light, darkHex: dark))
    }
    
    /// Creates Color from hex string
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
    
    // MARK: - Structured Color Access
    enum General {
        static let primary: Color = Color.adaptive(light: ColorConstants.primaryBackground.light, dark: ColorConstants.primaryBackground.dark)
        static let secondary: Color = Color.adaptive(light: ColorConstants.primaryText.light, dark: ColorConstants.primaryText.dark)
    }
    
    enum Text {
        static let primary: Color = Color.adaptive(light: ColorConstants.primaryText.light, dark: ColorConstants.primaryText.dark)
        static let secondary: Color = Color.adaptive(light: ColorConstants.secondaryText.light, dark: ColorConstants.secondaryText.dark)
        static let date: Color = Color(uiColor: .systemGray)
    }
    
    enum Brand {
        static let yellow: Color = Color.adaptive(light: ColorConstants.brandYellow.light, dark: ColorConstants.brandYellow.dark)
    }
}
