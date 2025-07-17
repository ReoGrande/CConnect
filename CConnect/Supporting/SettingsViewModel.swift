//
//  SettingsViewModel.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/17/25.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var currentMode: Mode = UserSettings.shared.mode

    func toggleMode() {

        UserSettings.shared.mode = (UserSettings.shared.mode == .user) ? .admin : .user
        currentMode = UserSettings.shared.mode
    }
}
