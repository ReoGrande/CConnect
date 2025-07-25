//
//  HomeView.swift
//  CConnect
//
//  Created by Reo Ogundare on 6/27/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var userModel: UserModel
    @State var name: [String] = ["",""]
    @State var errorMessage: Bool = false

    var body: some View {
        if userModel.user.isSignedin() {
            ButtonsView(userModel: userModel)
        } else {
            VStack(spacing: 25) {
                Text("Buckeye Pole Vault Academy")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                VStack {
                    Text("Enter first and last name:")
                        .foregroundStyle(.secondary)
                        .font(.title2)
                    HStack {
                        TextField("First Name", text: $name[0])
                            .textFieldStyle(.roundedBorder)
                        TextField("Last Name", text: $name[1])
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(25)
                    if errorMessage {
                        Text("Please enter first name and last name")
                            .font(.caption)
                            .foregroundStyle(.red)
                    } else {
                        Text(" ")
                            .font(.caption)
                    }
                }
                Button("Submit") {
                    if !name[0].isEmpty && !name[1].isEmpty {
                        DispatchQueue.main.async {
                            userModel.setUserName(first: name[0], last: name[1])
                        }
                        print(userModel.user.getFullName())
                    } else {
                        errorMessage = true
                    }
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            .padding(25)
            .padding(.vertical, 50)
        }
    }
}

extension HomeView {
    struct ButtonsView: View {
        @Environment(\.openURL) var openURL
        @ObservedObject var settingsModel: SettingsViewModel = SettingsViewModel()
        @ObservedObject var userModel: UserModel
        @ObservedObject private var eventsModel: EventsModel = EventsModel()
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 15) {
                    VStack {
                        Text("Buckeye Pole Vault Academy")
                            .font(.title)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Divider()
                    }
                    .padding(.vertical, 25)
                        if userModel.user.isSignedin() {
                            Text("Hello \(userModel.user.firstName)!")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .bold()
                        }
                        else {
                            EmptyView()
                        }
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink {
                            Text("Announcements")
                        } label: {
                            Text("Announcements")
                        }
                        Spacer()
                        NavigationLink {
                            CalendarView(eventsModel: eventsModel, settingsModel: settingsModel)
                        } label: {
                            Text("BPVA Calendar")
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Visit BPVA Online") {
                            openURL(URL(string: "https://www.buckeyepolevaultacademy.com/")!)
                        }
                        Spacer()
                        NavigationLink {
                            SettingsView(settingsModel: settingsModel)
                        } label: {
                            Text("Settings")
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.vertical,15)
            }
        }
    }
}

#Preview {
    HomeView(userModel: UserModel.shared)
}

