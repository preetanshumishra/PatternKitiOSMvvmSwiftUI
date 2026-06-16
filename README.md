# PatternKit — MVVM + Coordinator (SwiftUI)

Part of **PatternKit**, a side-by-side reference codebase where the same small **Tasks** CRUD app is implemented once per architecture pattern across iOS and Android. Every module ships identical behaviour — the same domain model, the same three screens, the same mock data layer — so the only thing that varies is the architecture itself.

This module is the **plain MVVM** flavour on **SwiftUI**: `ObservableObject` view models expose `@Published` state, SwiftUI views observe it, and there is **no use-case layer** — view models talk to the repository directly. It's the most common starting point for a SwiftUI app and the baseline that the Clean and TCA modules build on. Navigation is lifted out of the views into a **Coordinator** (`AppCoordinator`): views fire intents like `showDetail(_:)` rather than owning `NavigationStack`/`.sheet` themselves — the MVVM-C variant.

## Stack

- **Language:** Swift
- **UI:** SwiftUI
- **Architecture:** MVVM (no domain layer) + Coordinator
- **DI:** Manual constructor injection (`AppContainer`)
- **Navigation:** Coordinator (`AppCoordinator` + `AppCoordinatorView`)
- **Deployment target:** iOS 17.0 minimum (built against the iOS 26.5 SDK)
- **Bundle ID:** `com.preetanshumishra.PatternKitiOSMvvmSwiftUI`

## The Tasks feature

A single-user task list. One entity (`TaskItem`: title, optional notes, optional due date, priority, completion). Three screens:

1. **List** — filter (All / Active / Completed), sort by due date or priority, swipe-to-delete, `+` to create.
2. **Detail** — read-only fields, toggle completion, edit, delete.
3. **Form** — create or edit (mode-driven), title validation (≤ 80 chars), due-date validation (not in the past), 600 ms mock async save.

Data comes from `MockTaskRepository` — an in-memory store seeded with ~12 tasks, with configurable artificial latency and failure rate for exercising loading and error states. No real network, no local persistence — intentionally, so the architecture stays the focus.

## Dependency injection

Manual constructor-based DI, no third-party container. `AppContainer` lazily creates the repository and hands it to each view model's initializer. Swap the binding to a real (URLSession-backed) repository later and the rest of the app is unaffected.

## Navigation (Coordinator)

`AppCoordinator` is an `ObservableObject` that owns the navigation state — the pushed `path` and the presented `sheet` route — plus the shared list view model. Views call semantic intents (`showDetail`, `presentCreate`, `presentEdit`, `popToList`) and never touch `NavigationStack` or `.sheet` directly. `AppCoordinatorView` hosts the single `NavigationStack(path:)` and `.sheet(item:)`, mapping each route to its screen in one place. That's the "C" in MVVM-C: navigation decisions live in one testable object instead of being scattered across the views.

## Project layout

```
PatternKitiOSMvvmSwiftUI/
├── Domain/        # TaskItem, Priority, TaskFilter, TaskSort
├── Data/          # TaskRepository (contract), MockTaskRepository, seed data
├── Views/         # TaskListView/-ViewModel, TaskDetailView, TaskFormView/-ViewModel
├── Coordinator/   # AppCoordinator + AppCoordinatorView
├── AppContainer.swift
└── PatternKitiOSMvvmSwiftUIApp.swift
```

## Build & run

Open `PatternKitiOSMvvmSwiftUI.xcodeproj` in Xcode, then ⌘R to build and run (⌘U for tests). SwiftUI previews are available on the view files.
