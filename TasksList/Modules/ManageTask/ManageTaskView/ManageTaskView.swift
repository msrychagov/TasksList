//
//  ManageTaskView.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import SwiftUI

struct ManageTaskView: View {
    // MARK: Source Properties
    @ObservedObject var state: ManageTaskState
    
    // MARK: Connetction Properties
    private let output: ManageTaskViewOutput
    
    // MARK: Lifecycle
    init(
        output: ManageTaskViewOutput,
        state: ManageTaskState
    ) {
        self.output = output
        self.state = state
    }
    
    // MARK: UI
    var body: some View {
        VStack(alignment: .leading) {
            titleTextField
            date
            descriptionTextField
        }
        .padding(.horizontal, 20)
        .onAppear {
            output.onAppear()
        }
    }
    
    private var titleTextField: some View {
        TextField(
            "Задача",
            text: Binding(
                get: { state.title },
                set: { output.onTitleChange($0) }
            )
        )
        .tint(Color.yellow)
        .font(.system(size: 34, weight: .bold))
        .foregroundStyle(.primary)
    }
    
    private var date: some View {
        Text("21/09/25")
            .foregroundStyle(Color.dateText)
    }
    
    private var descriptionTextField: some View {
        ZStack(alignment: .topLeading) {
            TightTextEditor(
                text: Binding(
                    get: { state.note },
                    set: { output.onDescriptionChange($0) }
                )
            )
            
            if state.note.isEmpty {
                Text("Описание")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16, weight: .regular))
            }
        }
//        .frame(minHeight: 140)
    }
    
}
