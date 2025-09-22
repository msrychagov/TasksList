//
//  ManageTaskProtocols.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

protocol ManageTaskViewInput: AnyObject {
    func setLoading(isLoading: Bool)
    func showTaskInfo(viewModel: ManageTaskModels.ShowInfo.ViewModel)
    func showUpdatedTitle(viewModel: ManageTaskModels.UpdateTitle.ViewModel)
    func showUpdatedDescription(viewModel: ManageTaskModels.UpdateDescription.ViewModel)
}

protocol ManageTaskViewOutput {
    func onAppear()
    func onTitleChange(_ text: String)
    func onDescriptionChange(_ text: String)
}

protocol ManageTaskInteractorInput {
    func loadTaskInfo(request: ManageTaskModels.ShowInfo.Request)
    func createTask(request: ManageTaskModels.ShowInfo.Request)
    func updateTask(request: ManageTaskModels.ShowInfo.Request)
    func updateTitle(request: ManageTaskModels.UpdateTitle.Request)
    func updateDescription(request: ManageTaskModels.UpdateDescription.Request)
}

protocol ManageTaskInteractorOutput: AnyObject {
    func didLoadTaskInfo(response: ManageTaskModels.ShowInfo.Response)
    func didFailToLoadTaskInfo(error: Error)
    func didUpdateTitle(response: ManageTaskModels.UpdateTitle.Response)
    func didUpdateDescription(response: ManageTaskModels.UpdateDescription.Response)
}

protocol ManageTaskRouterInput {
    
}

protocol ManageTaskWorkerInput {
    func loadTaskInfo(for id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void)
}
