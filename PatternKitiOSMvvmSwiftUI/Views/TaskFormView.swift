//
//  TaskFormView.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-21.
//

import SwiftUI

struct TaskFormView: View {
    @StateObject private var viewModel: TaskFormViewModel
    @Environment(\.dismiss) private var dismiss
    private let onSaved: (TaskItem) -> Void

    init(
        viewModel: @autoclosure @escaping () -> TaskFormViewModel,
        onSaved: @escaping (TaskItem) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.onSaved = onSaved
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("What needs doing?", text: $viewModel.title)
                }

                Section("Notes") {
                    TextField("Optional", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Due date") {
                    Toggle("Has due date", isOn: $viewModel.hasDueDate.animation())
                    if viewModel.hasDueDate {
                        DatePicker(
                            "Date",
                            selection: $viewModel.dueDate,
                            displayedComponents: .date
                        )
                    }
                }

                Section("Priority") {
                    Picker("Priority", selection: $viewModel.priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.displayName).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task { await save() }
                    }
                    .disabled(!viewModel.isValid || viewModel.isSaving)
                }
            }
            .alert(
                "Couldn't save",
                isPresented: errorBinding,
                presenting: viewModel.errorMessage
            ) { _ in
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: { message in
                Text(message)
            }
        }
    }

    private func save() async {
        guard let saved = await viewModel.save() else { return }
        onSaved(saved)
        dismiss()
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

#Preview("Create") {
    TaskFormView(
        viewModel: TaskFormViewModel(mode: .create, repository: MockTaskRepository())
    ) { _ in }
}

#Preview("Edit") {
    let sample = TaskItem(
        title: "Plan Q3 roadmap",
        notes: "Draft the high-level themes first.",
        dueDate: Date(),
        priority: .high
    )
    return TaskFormView(
        viewModel: TaskFormViewModel(mode: .edit(sample), repository: MockTaskRepository())
    ) { _ in }
}
