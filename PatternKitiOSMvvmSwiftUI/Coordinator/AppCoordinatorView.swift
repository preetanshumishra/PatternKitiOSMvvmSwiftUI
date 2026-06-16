//
//  AppCoordinatorView.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-06-06.
//
//  The coordinator's view counterpart: it owns the single `NavigationStack`
//  (driven by `coordinator.path`) and the single `.sheet` presentation. Mapping
//  a route to a concrete screen happens here and nowhere else, so the list and
//  detail views stay unaware of how they're presented.
//

import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator

    init(coordinator: @autoclosure @escaping () -> AppCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator())
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            TaskListView(viewModel: coordinator.listViewModel, coordinator: coordinator)
                .navigationDestination(for: AppCoordinator.Route.self) { route in
                    switch route {
                    case .detail(let id):
                        TaskDetailView(
                            taskID: id,
                            viewModel: coordinator.listViewModel,
                            coordinator: coordinator
                        )
                    }
                }
        }
        .sheet(item: $coordinator.sheet) { sheet in
            TaskFormView(viewModel: coordinator.makeFormViewModel(for: sheet)) { saved in
                coordinator.listViewModel.apply(saved)
            }
        }
    }
}
