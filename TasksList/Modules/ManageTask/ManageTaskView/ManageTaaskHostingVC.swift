//
//  ManageTaaskHostingVC.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import SwiftUI

final class ManageTaaskHostingVC: UIHostingController<ManageTaskView>, ManageTaskViewInput {
    // MARK: State
    private let state: ManageTaskState
    
    // MARK: Lifecycle
    init(
        output: ManageTaskViewOutput,
        state: ManageTaskState = .init()
    ) {
        self.state = state
        let rootView = ManageTaskView(output: output)
        super.init(rootView: rootView)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ManageTaskViewInput Methods
    func setLoading(isLoading: Bool) {
        state.phase = .loading
    }
    
    func showTaskInfo(viewModel: ManageTaskModels.ShowInfo.ViewModel) {
        print(viewModel)
    }
}

