//
//  AppContainer.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-11.
//

import Foundation

@MainActor
final class AppContainer {
    let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository? = nil) {
        self.taskRepository = taskRepository ?? MockTaskRepository()
    }
    
    func makeTaskListViewModel() -> TaskListViewModel {
        TaskListViewModel(repository: taskRepository)
    }

    func makeTaskFormViewModel(mode: TaskFormViewModel.Mode) -> TaskFormViewModel {
        TaskFormViewModel(mode: mode, repository: taskRepository)
    }
}
