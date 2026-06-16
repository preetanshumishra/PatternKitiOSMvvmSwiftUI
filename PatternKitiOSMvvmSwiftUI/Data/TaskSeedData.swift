//
//  TaskSeedData.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-15.
//

import Foundation

enum TaskSeedData {
    private static let secondsPerDay: TimeInterval = 86_400
    
    private static func daysFromNow(_ offset: Int) -> Date {
        Date().addingTimeInterval(secondsPerDay * Double(offset))
    }
    
    nonisolated static let tasks: [TaskItem] = [
        TaskItem(
            title: "Review PR for auth refactor",
            notes: "Pay attention to the token refresh path.",
            dueDate: daysFromNow(-1),
            priority: .high
        ),
        TaskItem(
            title: "Plan Q3 roadmap",
            dueDate: daysFromNow(2),
            priority: .high
        ),
        TaskItem(
            title: "Reply to support emails",
            priority: .medium
        ),
        TaskItem(
            title: "Update SDK docs",
            notes: "Section on token refresh is stale.",
            dueDate: daysFromNow(5),
            priority: .medium
        ),
        TaskItem(
            title: "Renew domain",
            dueDate: daysFromNow(14),
            priority: .low
        ),
        TaskItem(
            title: "Pick up dry cleaning",
            dueDate: daysFromNow(0),
            priority: .low
        ),
        TaskItem(
            title: "Investigate flaky integration test",
            notes: "Reproduces ~1 in 8 runs on CI.",
            priority: .high,
            isCompleted: true
        ),
        TaskItem(
            title: "Wireframe onboarding flow",
            dueDate: daysFromNow(-3),
            priority: .medium,
            isCompleted: true
        ),
        TaskItem(
            title: "Book flight for conference",
            dueDate: daysFromNow(21),
            priority: .medium
        ),
        TaskItem(
            title: "1:1 prep — direct reports",
            dueDate: daysFromNow(1),
            priority: .high
        ),
        TaskItem(
            title: "Refactor logging module",
            priority: .low,
            isCompleted: true
        ),
        TaskItem(
            title: "Buy birthday gift",
            dueDate: daysFromNow(7),
            priority: .medium
        ),
    ]
}
