//
//  TaskSort.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-13.
//

import Foundation

enum TaskSort: String, CaseIterable, Identifiable {
    case dueDate
    case priority
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .dueDate:  return "Due Date"
        case .priority: return "Priority"
        }
    }
    
    func sorted(_ tasks: [TaskItem]) -> [TaskItem] {
        switch self {
        case .dueDate:
            return tasks.sorted { lhs, rhs in
                switch (lhs.dueDate, rhs.dueDate) {
                case (nil, nil):    return lhs.createdAt > rhs.createdAt
                case (nil, _):      return false
                case (_, nil):      return true
                case let (l?, r?):  return l < r
                }
            }
        case .priority:
            return tasks.sorted { lhs, rhs in
                if lhs.priority.sortOrder != rhs.priority.sortOrder {
                    return lhs.priority.sortOrder < rhs.priority.sortOrder
                }
                return lhs.createdAt > rhs.createdAt
            }
        }
    }
}
