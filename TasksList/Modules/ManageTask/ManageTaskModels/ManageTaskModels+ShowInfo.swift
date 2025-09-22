//
//  ManageTaskModels+ShowInfo.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

extension ManageTaskModels {
    enum ShowInfo {
        struct Request {
            
        }
        
        struct Response {
            let task: TaskItem
        }
        
        struct ViewModel {
            let info: ManageTaskViewModel
        }
    }
}
