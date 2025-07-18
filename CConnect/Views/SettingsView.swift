//
//  SettingsView.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/17/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsModel: SettingsViewModel
    @State private var onOff: String = "Off"
    @State private var modalPresented: Bool = false
    @State private var password: String = ""

    var body: some View {
        VStack {
            Spacer()
            List {
                HStack {
                    Spacer()
                    Button("Admin mode: \(settingsModel.currentMode == .admin ? "On" : "Off")") {
                        modalPresented = !modalPresented
                    }
                    .buttonStyle(.bordered)
                    .sheet(isPresented: $modalPresented) {
                        createLoginView()
                    }

                    Spacer()

                    Button("Log out") {
                        settingsModel.currentMode = .user
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            Spacer()
        }
    }

    func createLoginView() -> some View {
        VStack {
            Spacer()
            HStack(spacing: 30) {
                Spacer()
                TextField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                Spacer()
            }

            Button("Submit") {
                if password == adminPassword {
                    settingsModel.currentMode = .admin
                    modalPresented = !modalPresented
                    password = ""
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}

// TODO: REMOVE FOR SECURITY IN THE FUTURE, STORE AS HASH IN FIREBASE, REVIEW PASSWORD VERIFICATION STANDARDS
private let adminPassword: String = "TheCoolestDawgFrank"
