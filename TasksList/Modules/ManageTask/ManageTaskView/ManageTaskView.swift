//
//  ManageTaskView.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import SwiftUI
import Foundation

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
            detailsTextField
        }
        .padding(.horizontal, UIConstants.Spacing.horizontalPage)
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
        .tint(.Brand.yellow)
        .font(.system(size: UIConstants.Fonts.titleSize, weight: .bold))
        .foregroundStyle(.primary)
    }
    
    private var date: some View {
        Text(state.date)
            .foregroundStyle(Color.Text.date)
    }
    
    private var detailsTextField: some View {
        ZStack(alignment: .topLeading) {
            TightTextEditor(
                text: Binding(
                    get: { state.note },
                    set: { output.onDescriptionChange($0) }
                )
            )
            
            if state.note.isEmpty {
                Text("Описание")
                    .foregroundStyle(Color.Text.secondary)
                    .font(.system(size: UIConstants.Fonts.bodySize, weight: .regular))
                    .allowsHitTesting(false)
            }
        }
        .frame(minHeight: UIConstants.Sizing.detailsMinHeight)
    }
    
}
