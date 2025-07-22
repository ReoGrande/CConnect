//
//  HomeView.swift
//  CConnect
//
//  Created by Reo Ogundare on 6/27/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        ButtonsView()
    }
}

extension HomeView {
    struct ButtonsView: View {
        @Environment(\.openURL) var openURL
        @ObservedObject var settingsModel: SettingsViewModel = SettingsViewModel()
        @ObservedObject var userModel: UserModel = UserModel.shared
        @ObservedObject private var eventsModel: EventsModel = EventsModel()
        @State var name: [String] = ["",""]
        
        var body: some View {
            VStack(spacing: 25) {
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
                VStack(spacing: 15) {
                    Text("Enter First and Last name")
                    HStack {
                        TextField("First Name", text: $name[0])
                        TextField("Last Name", text: $name[1])
                    }
                    .padding(15)
                    Button("Submit") {
                        if !name[0].isEmpty && !name[1].isEmpty {
                            userModel.setUserName(first: name[0], last: name[1])
                            print(userModel.user.getFullName())
                        }
                    }

                    if !userModel.user.getFullName().isEmpty {
                        Text("Hello \(userModel.user.getFullName())")
                            .bold()
                    }
                }
                Spacer()
            }
            .frame(minHeight: 25, maxHeight: 50)
            .task {
                await userModel.decodeFromLocal()
            }
        }
    }
}

#Preview {
    HomeView()
}

