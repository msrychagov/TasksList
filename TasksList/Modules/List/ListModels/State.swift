//
//  State.swift
//  TasksList
//
//  Created by Михаил Рычагов on 15.09.2025.
//

enum State<VM> {
    case success(VM)
    case failure(message: String)
}
