//
//  Priority.swift
//  PatternKitiOSMvvmSwiftUI
//
//  Created by Preetanshu Mishra on 2026-05-13.
//

import Foundation

enum Priority: String, CaseIterable, Identifiable, Equatable {
    case low
    case medium
    case high
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .low:    return "Low"
        case .medium: return "Medium"
        case .high:   return "High"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .high:   return 0
        case .medium: return 1
        case .low:    return 2
        }
    }
}
