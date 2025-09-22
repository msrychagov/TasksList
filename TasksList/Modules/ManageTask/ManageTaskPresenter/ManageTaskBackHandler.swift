//
//  ManageTaskBackHandler.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

protocol ManageTaskBackHandler: AnyObject {
    func onBackCommit(title: String, description: String)
}
