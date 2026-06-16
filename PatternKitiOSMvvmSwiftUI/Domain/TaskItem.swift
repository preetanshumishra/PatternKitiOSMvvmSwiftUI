//
//  TaskItem.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-13.
//

import Foundation

struct TaskItem: Identifiable, Equatable, Sendable {
    let id: UUID
    var title: String
    var notes: String?
    var dueDate: Date?
    var priority: Priority
    var isCompleted: Bool
    let createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
        title: String,
        notes: String? = nil,
        dueDate: Date? = nil,
        priority: Priority = .medium,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
