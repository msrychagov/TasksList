//
//  ManageTaskState.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

final class ManageTaskState: ObservableObject {
    enum Phase {
        case idle
        case loading
        case loaded
        case error(String)
    }
    // MARK: UI Properties
    @Published var phase: Phase = .idle
    @Published var title: String = ""
    @Published var note: String = ""
    @Published var date: String = ""
}
