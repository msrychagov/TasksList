//
//  String+FuzzySearch.swift
//  TasksList
//
//  Created by Михаил Рычагов on 18.09.2025.
//

import Foundation

extension String {
    func matched(with target: String) -> Bool {
        return levenshteinDistance(to: target) <= 2 || self.contains(target)
    }
    func contains(_ target: String) -> Bool {
        let sourceArray = Array(self.lowercased())
        let targetArray = Array(target.lowercased())
        let sourceCount = sourceArray.count
        let targetCount = targetArray.count
        var sIdx = 0
        var tIdx = 0
        while sIdx < sourceCount {
            if targetArray[tIdx] == sourceArray[sIdx] {
                tIdx += 1
                if tIdx == targetCount { return true }
            }
            sIdx += 1
        }
        return false
    }
    func levenshteinDistance(to target: String) -> Int {
        let sourceArray = Array(self)
        let targetArray = Array(target)
        let sourceCount = sourceArray.count
        let targetCount = targetArray.count
        guard sourceCount != 0 else { return targetCount }
        guard targetCount != 0 else { return sourceCount }
        var distanceMatrix = [[Int]](
            repeating: [Int](repeating: 0, count: targetCount + 1),
            count: sourceCount + 1
        )
        for rowIndex in 0...sourceCount { distanceMatrix[rowIndex][0] = rowIndex }
        for columnIndex in 0...targetCount { distanceMatrix[0][columnIndex] = columnIndex }
        for rowIndex in 1...sourceCount {
            for columnIndex in 1...targetCount {
                let substitutionCost = sourceArray[rowIndex - 1] == targetArray[columnIndex - 1] ? 0 : 1
                distanceMatrix[rowIndex][columnIndex] = Swift.min(
                    distanceMatrix[rowIndex - 1][columnIndex] + 1,
                    distanceMatrix[rowIndex][columnIndex - 1] + 1,
                    distanceMatrix[rowIndex - 1][columnIndex - 1] + substitutionCost
                )
            }
        }
        return distanceMatrix[sourceCount][targetCount]
    }
}

