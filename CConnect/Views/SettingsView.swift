//
//  SettingsView.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/17/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var onOff: String = "Off"

    var body: some View {
        VStack {
            Spacer()
            List {
                Button("Admin mode") {
                    DispatchQueue.main.async {
                        settingsViewModel.toggleMode()
                    }
                }
                Text("Admin mode: \(settingsViewModel.currentMode == .admin ? "On" : "Off")")
            }
            Spacer()
        }
    }
}
