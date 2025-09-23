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
    func onDisappear(title: String, details: String)
    func onTitleChange(_ text: String)
    func onDescriptionChange(_ text: String)
}

protocol ManageTaskInteractorInput {
    func loadTaskInfo(request: ManageTaskModels.ShowInfo.Request)
    func saveTaskInfo(request: ManageTaskModels.SaveTaskInfo.Request)
    func updateTitle(request: ManageTaskModels.UpdateTitle.Request)
    func updateDescription(request: ManageTaskModels.UpdateDescription.Request)
}

protocol ManageTaskInteractorOutput: AnyObject {
    func didLoadTaskInfo(response: ManageTaskModels.ShowInfo.Response)
    func didStartCreate(response: ManageTaskModels.Create.Response)
    func didFailToLoadTaskInfo(error: Error)
    func didUpdateTitle(response: ManageTaskModels.UpdateTitle.Response)
    func didUpdateDescription(response: ManageTaskModels.UpdateDescription.Response)
}

protocol ManageTaskRouterInput {
    
}

protocol ManageTaskWorkerInput {
    func loadTaskInfo(for id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void)
    func updateTask(with id: UUID, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void)
    func createTask(title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void)
}
