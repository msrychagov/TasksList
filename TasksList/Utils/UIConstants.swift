//
//  UIConstants.swift
//  TasksList
//
//  Centralized UI numeric constants: spacing, sizing, fonts, radii.
//

import Foundation
import CoreGraphics

enum UIConstants {
    enum Spacing {
        static let horizontalPage: CGFloat = 20
        static let cellTitleTop: CGFloat = 12
        static let cellTitleLeftAfterIcon: CGFloat = 8
        static let cellSubtitleTop: CGFloat = 6
        static let cellDateTop: CGFloat = 6
        static let cellDateBottom: CGFloat = 12
        static let emptyHorizontal: CGFloat = 24
        static let summaryTopToBorder: CGFloat = 20
        static let createButtonTop: CGFloat = 13
    }

    enum Sizing {
        static let detailsMinHeight: CGFloat = 140
        static let doneButtonWidth: CGFloat = 24
        static let doneButtonHeight: CGFloat = 48
        static let cellTitleHeight: CGFloat = 22
        static let dateLabelHeight: CGFloat = 16
        static let emptyIconSize: CGFloat = 56
        static let summaryBorderHeight: CGFloat = 0.33
        static let createButtonWidth: CGFloat = 68
        static let createButtonHeight: CGFloat = 28
        static let summaryViewHeight: CGFloat = 83
        static let tableEstimatedRowHeight: CGFloat = 72
        static let tableHeaderHeight: CGFloat = 1
    }

    enum Fonts {
        static let titleSize: CGFloat = 34
        static let bodySize: CGFloat = 16
        static let cellTitle: CGFloat = 16
        static let cellSubtitle: CGFloat = 12
        static let summaryLabel: CGFloat = 11
        static let emptyTitle: CGFloat = 28
    }

    enum Stack {
        static let emptyTitleSpacingAfter: CGFloat = 12
        static let emptyStackSpacing: CGFloat = 20
    }
}


