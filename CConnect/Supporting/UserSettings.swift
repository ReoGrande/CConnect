//
//  UserSettings.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/17/25.
//

import Foundation

/// Manages user settings application wide
class UserSettings: ObservableObject {
    
    static let shared = UserSettings()
    // Default Value for user mode in settings
    @Published var mode: Mode = .user
    private init() {} // Prevent creating multiple instances
}

enum Mode {
    case admin, user
}
