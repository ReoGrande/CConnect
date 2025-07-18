//
//  UserSettings.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/17/25.
//

import Foundation

class UserSettings: ObservableObject {
    
    static let shared = UserSettings()
    // Default Value
    @Published var mode: Mode = .admin
    private init() {} // Prevent creating multiple instances
}

enum Mode {
    case admin, user
}
