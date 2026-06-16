//
//  TaskFormViewModel.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-21.
//

import Combine
import Foundation

@MainActor
final class TaskFormViewModel: ObservableObject {
    enum Mode {
        case create
        case edit(TaskItem)
    }

    @Published var title: String
    @Published var notes: String
    @Published var hasDueDate: Bool
    @Published var dueDate: Date
    @Published var priority: Priority
    @Published private(set) var isSaving = false
    @Published var errorMessage: String?

    let mode: Mode
    private let repository: TaskRepository

    init(mode: Mode, repository: TaskRepository) {
        self.mode = mode
        self.repository = repository

        switch mode {
        case .create:
            title = ""
            notes = ""
            hasDueDate = false
            dueDate = Date()
            priority = .medium
        case .edit(let task):
            title = task.title
            notes = task.notes ?? ""
            hasDueDate = task.dueDate != nil
            dueDate = task.dueDate ?? Date()
            priority = task.priority
        }
    }

    var navigationTitle: String {
        switch mode {
        case .create: return "New Task"
        case .edit:   return "Edit Task"
        }
    }

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Persists the task and returns the saved value on success, or `nil` on
    /// validation/repository failure (in which case `errorMessage` is set).
    func save() async -> TaskItem? {
        guard isValid else { return nil }
        isSaving = true
        defer { isSaving = false }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedNotes = trimmedNotes.isEmpty ? nil : trimmedNotes
        let resolvedDueDate = hasDueDate ? dueDate : nil

        do {
            switch mode {
            case .create:
                let draft = TaskItem(
                    title: trimmedTitle,
                    notes: resolvedNotes,
                    dueDate: resolvedDueDate,
                    priority: priority
                )
                return try await repository.create(draft)

            case .edit(let original):
                var edited = original
                edited.title = trimmedTitle
                edited.notes = resolvedNotes
                edited.dueDate = resolvedDueDate
                edited.priority = priority
                edited.updatedAt = Date()
                return try await repository.update(edited)
            }
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
