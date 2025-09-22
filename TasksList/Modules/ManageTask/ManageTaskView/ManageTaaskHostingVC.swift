//
//  ManageTaaskHostingVC.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import SwiftUI

final class ManageTaaskHostingVC: UIHostingController<ManageTaskView>, ManageTaskViewInput {
    // MARK: State
    private let state: ManageTaskState = ManageTaskState()
    
    // MARK: Action Handlers
    weak var backTapHandler: ManageTaskBackHandler?
    
    // MARK: Lifecycle
    init(
        output: ManageTaskViewOutput
    ) {
        let rootView = ManageTaskView(output: output, state: state)
        super.init(rootView: rootView)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            backTapHandler?.onBackCommit(title: state.title, description: state.note)
        }
    }
    
    // MARK: ManageTaskViewInput Methods
    func setLoading(isLoading: Bool) {
        state.phase = .loading
    }
    
    func showTaskInfo(viewModel: ManageTaskModels.ShowInfo.ViewModel) {
        print(viewModel.info)
        DispatchQueue.main.async { [weak self] in
            self?.state.title = viewModel.info.title
            self?.state.note = viewModel.info.note
            self?.state.date = viewModel.info.date
        }
    }
    
    func showUpdatedTitle(viewModel: ManageTaskModels.UpdateTitle.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.state.title = viewModel.text
        }
    }
    
    func showUpdatedDescription(viewModel: ManageTaskModels.UpdateDescription.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.state.note = viewModel.text
        }
    }
}

