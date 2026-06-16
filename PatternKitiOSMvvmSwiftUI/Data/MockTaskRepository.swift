//
//  MockTaskRepository.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-13.
//

import Foundation

@MainActor
final class MockTaskRepository: TaskRepository {
    private var tasks: [TaskItem]
    private let latency: Duration
    private let failureRate: Double
    
    init(
        seed: [TaskItem] = TaskSeedData.tasks,
        latency: Duration = .milliseconds(600),
        failureRate: Double = 0.0
    ) {
        self.tasks = seed
        self.latency = latency
        self.failureRate = max(0.0, min(1.0, failureRate))
    }
    
    func fetchAll() async throws -> [TaskItem] {
        try await simulateWork()
        return tasks
    }
    
    func create(_ task: TaskItem) async throws -> TaskItem {
        try await simulateWork()
        tasks.append(task)
        return task
    }
    
    func update(_ task: TaskItem) async throws -> TaskItem {
        try await simulateWork()
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            throw TaskRepositoryError.notFound
        }
        var updated = task
        updated.updatedAt = Date()
        tasks[index] = updated
        return updated
    }
    
    func delete(id: UUID) async throws {
        try await simulateWork()
        guard tasks.contains(where: { $0.id == id }) else {
            throw TaskRepositoryError.notFound
        }
        tasks.removeAll { $0.id == id }
    }
    
    private func simulateWork() async throws {
        try await Task.sleep(for: latency)
        if failureRate > 0, Double.random(in: 0..<1) < failureRate {
            throw TaskRepositoryError.simulated
        }
    }
}
