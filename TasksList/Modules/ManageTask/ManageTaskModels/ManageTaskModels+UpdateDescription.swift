//
//  ManageTaskModels+UpdateDescription.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

extension ManageTaskModels {
    enum UpdateDescription {
        struct Request {
            let text: String
        }
        
        struct Response {
            let text: String
        }
        
        struct ViewModel {
            let text: String
        }
    }
}
