//
//  TaskRepository.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-13.
//

import Foundation

protocol TaskRepository {
    func fetchAll() async throws -> [TaskItem]
    func create(_ task: TaskItem) async throws -> TaskItem
    func update(_ task: TaskItem) async throws -> TaskItem
    func delete(id: UUID) async throws
}

enum TaskRepositoryError: Error, LocalizedError {
    case notFound
    case simulated
    
    var errorDescription: String? {
        switch self {
        case .notFound:  return "Task not found."
        case .simulated: return "Something went wrong. Please try again."
        }
    }
}
