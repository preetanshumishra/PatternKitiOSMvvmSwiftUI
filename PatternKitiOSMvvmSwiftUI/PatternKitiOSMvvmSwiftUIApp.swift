//
//  PatternKitiOSMvvmSwiftUIApp.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-11.
//

import SwiftUI

@main
struct PatternKitiOSMvvmSwiftUIApp: App {
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: AppCoordinator(container: container))
        }
    }
}
