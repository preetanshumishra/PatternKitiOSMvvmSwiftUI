//
//  TaskDetailView.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-21.
//

import SwiftUI

struct TaskDetailView: View {
    let taskID: UUID
    @ObservedObject var viewModel: TaskListViewModel
    let coordinator: AppCoordinator

    private var task: TaskItem? { viewModel.task(id: taskID) }

    var body: some View {
        Group {
            if let task {
                detail(for: task)
            } else {
                ContentUnavailableView(
                    "Task unavailable",
                    systemImage: "questionmark.folder",
                    description: Text("It may have been deleted.")
                )
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let task {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { coordinator.presentEdit(task) }
                }
            }
        }
    }

    @ViewBuilder
    private func detail(for task: TaskItem) -> some View {
        List {
            Section {
                HStack {
                    Text(task.title)
                        .font(.title3.weight(.semibold))
                        .strikethrough(task.isCompleted)
                    Spacer()
                    priorityLabel(task.priority)
                }
            }

            if let notes = task.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }

            Section {
                if let due = task.dueDate {
                    LabeledContent("Due", value: due.formatted(date: .abbreviated, time: .omitted))
                }
                LabeledContent("Status", value: task.isCompleted ? "Completed" : "Active")
            }

            Section {
                Button {
                    Task { await viewModel.toggleCompletion(task) }
                } label: {
                    Label(
                        task.isCompleted ? "Mark as active" : "Mark as completed",
                        systemImage: task.isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle"
                    )
                }

                Button(role: .destructive) {
                    Task {
                        await viewModel.delete(task)
                        coordinator.popToList()
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    private func priorityLabel(_ priority: Priority) -> some View {
        Text(priority.displayName)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priorityColor(priority).opacity(0.15))
            .foregroundStyle(priorityColor(priority))
            .clipShape(Capsule())
    }

    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .high:   return .red
        case .medium: return .orange
        case .low:    return .blue
        }
    }
}

#Preview {
    let coordinator = AppCoordinator(container: AppContainer(taskRepository: MockTaskRepository(latency: .zero)))
    let sample = TaskItem(
        title: "Review PR for auth refactor",
        notes: "Pay attention to the token refresh path.",
        dueDate: Date(),
        priority: .high
    )
    coordinator.listViewModel.apply(sample)

    return NavigationStack {
        TaskDetailView(
            taskID: sample.id,
            viewModel: coordinator.listViewModel,
            coordinator: coordinator
        )
    }
}
