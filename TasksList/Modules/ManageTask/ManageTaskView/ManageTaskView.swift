//
//  ManageTaskView.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import SwiftUI

struct ManageTaskView: View {
    // MARK: Properties
    private let output: ManageTaskViewOutput
    
    // MARK: Lifecycle
    init(output: ManageTaskViewOutput) {
        self.output = output
    }
    
    // MARK: UI
    var body: some View {
        Text("ManageTaskView")
    }
}
