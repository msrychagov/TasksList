//
//  ManageTaskModels+Create.swift
//  TasksList
//
//  Created by Михаил Рычагов on 19.09.2025.
//

import Foundation

extension ManageTaskModels {
    enum Create {
        struct Request {
            
        }
        
        struct Response {
            let date: Date
        }
        
        struct ViewModel {
            let date: String
        }
    }
}
