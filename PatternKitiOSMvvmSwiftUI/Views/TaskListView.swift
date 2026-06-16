//
//  TaskListView.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-19.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel
    let coordinator: AppCoordinator

    var body: some View {
        ZStack {
            content
            floatingActionButton
        }
        .navigationTitle("Tasks")
        .toolbar { sortToolbar }
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .alert(
            "Something went wrong",
            isPresented: errorBinding,
            presenting: viewModel.errorMessage
        ) { _ in
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: { message in
            Text(message)
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            filterChips
            taskList
        }
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TaskFilter.allCases) { filter in
                    FilterChip(
                        title: filter.displayName,
                        isSelected: viewModel.filter == filter
                    ) {
                        viewModel.filter = filter
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private var taskList: some View {
        if viewModel.isLoading && viewModel.displayedTasks.isEmpty {
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.displayedTasks.isEmpty {
            ContentUnavailableView(
                "No tasks",
                systemImage: "checklist",
                description: Text("Tap + to add one.")
            )
        } else {
            List {
                ForEach(viewModel.displayedTasks) { task in
                    Button {
                        coordinator.showDetail(task.id)
                    } label: {
                        TaskRow(task: task) {
                            Task { await viewModel.toggleCompletion(task) }
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            Task { await viewModel.delete(task) }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    private var floatingActionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    coordinator.presentCreate()
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .frame(width: 56, height: 56)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, y: 2)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }

    @ToolbarContentBuilder
    private var sortToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Sort", selection: $viewModel.sort) {
                    ForEach(TaskSort.allCases) { sort in
                        Text(sort.displayName).tag(sort)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.clearError() } }
        )
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? Color.accentColor : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                HStack(spacing: 8) {
                    PriorityBadge(priority: task.priority)
                    if let due = task.dueDate {
                        Text(due, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

private struct PriorityBadge: View {
    let priority: Priority

    var body: some View {
        Text(priority.displayName)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private var color: Color {
        switch priority {
        case .high:   return .red
        case .medium: return .orange
        case .low:    return .blue
        }
    }
}

#Preview {
    let coordinator = AppCoordinator(container: AppContainer(taskRepository: MockTaskRepository()))
    return NavigationStack {
        TaskListView(viewModel: coordinator.listViewModel, coordinator: coordinator)
    }
}
