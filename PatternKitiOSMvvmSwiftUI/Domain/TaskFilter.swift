//
//  TaskFilter.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-13.
//

import Foundation

enum TaskFilter: String, CaseIterable, Identifiable {
    case all
    case active
    case completed
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .all:       return "All"
        case .active:    return "Active"
        case .completed: return "Completed"
        }
    }
    
    func matches(_ task: TaskItem) -> Bool {
        switch self {
        case .all:       return true
        case .active:    return !task.isCompleted
        case .completed: return task.isCompleted
        }
    }
}
