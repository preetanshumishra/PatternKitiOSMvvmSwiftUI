//
//  AppCoordinator.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//
//  Coordinator (the "C" in MVVM-C). It owns the navigation state — the pushed
//  `path` and the presented `sheet` — so the views no longer decide where to
//  go. Screens call semantic intents (`showDetail`, `presentCreate`, …) and the
//  coordinator translates them into route changes. It also holds the shared
//  list ViewModel, the single source of truth the list and detail screens read.
//

import Combine
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    /// Pushed destinations. A typed array (rather than an opaque
    /// `NavigationPath`) keeps the navigation stack inspectable from one place.
    @Published var path: [Route] = []

    /// The modally presented form, if any. `nil` means no sheet.
    @Published var sheet: SheetRoute?

    enum Route: Hashable {
        case detail(UUID)
    }

    enum SheetRoute: Identifiable {
        case create
        case edit(TaskItem)

        var id: String {
            switch self {
            case .create:          return "create"
            case .edit(let task):  return "edit-\(task.id)"
            }
        }
    }

    /// Shared by the list and detail screens — owning it here means child
    /// screens don't have to thread it through every navigation call.
    let listViewModel: TaskListViewModel

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        self.listViewModel = container.makeTaskListViewModel()
    }

    // MARK: - Navigation intents

    func showDetail(_ id: UUID) {
        path.append(.detail(id))
    }

    func presentCreate() {
        sheet = .create
    }

    func presentEdit(_ task: TaskItem) {
        sheet = .edit(task)
    }

    func popToList() {
        path.removeAll()
    }

    // MARK: - Child construction

    func makeFormViewModel(for sheet: SheetRoute) -> TaskFormViewModel {
        switch sheet {
        case .create:         return container.makeTaskFormViewModel(mode: .create)
        case .edit(let task): return container.makeTaskFormViewModel(mode: .edit(task))
        }
    }
}
