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
}

protocol ManageTaskViewOutput {
    func onAppear()
}

protocol ManageTaskInteractorInput {
    func loadTaskInfo(request: ManageTaskModels.ShowInfo.Request)
    func createTask(request: ManageTaskModels.ShowInfo.Request)
    func updateTask(request: ManageTaskModels.ShowInfo.Request)
}

protocol ManageTaskInteractorOutput: AnyObject {
    func didLoadTaskInfo(response: ManageTaskModels.ShowInfo.Response)
    func didFailToLoadTaskInfo(error: Error)
}

protocol ManageTaskRouterInput {
    
}

protocol ManageTaskWorkerInput {
    func loadTaskInfo(for id: UUID, completion: @escaping (Result<TaskItem, Error>) -> Void)
}
