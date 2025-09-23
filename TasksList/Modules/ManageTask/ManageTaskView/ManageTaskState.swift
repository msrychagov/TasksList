//
//  ManageTaskState.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

final class ManageTaskState: ObservableObject {
    // MARK: UI Properties
    @Published var title: String = ""
    @Published var note: String = ""
    @Published var date: String = Date().dmyslash()
}
