//
//  TaskListViewModel.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-19.
//

import Foundation
import Combine

@MainActor
final class TaskListViewModel: ObservableObject {
    @Published private(set) var displayedTasks: [TaskItem] = []
    @Published var filter: TaskFilter = .all
    @Published var sort: TaskSort = .dueDate
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published private var allTasks: [TaskItem] = []
    
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
        
        Publishers.CombineLatest3($allTasks, $filter, $sort)
            .map { tasks, filter, sort in
                sort.sorted(tasks.filter(filter.matches))
            }
            .assign(to: &$displayedTasks)
    }
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        await fetch()
    }
    
    func refresh() async {
        await fetch()
    }
    
    func toggleCompletion(_ task: TaskItem) async {
        var updated = task
        updated.isCompleted.toggle()
        updated.updatedAt = Date()
        
        do {
            let saved = try await repository.update(updated)
            replaceInAllTasks(saved)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func delete(_ task: TaskItem) async {
        do {
            try await repository.delete(id: task.id)
            allTasks.removeAll { $0.id == task.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        errorMessage = nil
    }

    /// Look up a task by id across the full (unfiltered) set, so a detail
    /// screen can still find a task the active filter would hide.
    func task(id: UUID) -> TaskItem? {
        allTasks.first { $0.id == id }
    }

    /// Insert a new task or replace an existing one. Called after the form
    /// VM persists a create/edit, keeping the list in sync without a refetch.
    func apply(_ task: TaskItem) {
        if let index = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks[index] = task
        } else {
            allTasks.append(task)
        }
    }
    
    private func fetch() async {
        do {
            allTasks = try await repository.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func replaceInAllTasks(_ task: TaskItem) {
        guard let idx = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[idx] = task
    }
}
