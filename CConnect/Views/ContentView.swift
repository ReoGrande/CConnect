//
//  ContentView.swift
//  CConnect
//
//  Created by Reo Ogundare on 2/27/25.
//  Credits to: https://swiftpackageindex.com/AllanJuenemann/CalendarView,
//  https://github.com/Mijick/CalendarView
//

import SwiftUI
import SwiftData
import MijickCalendarView

struct ContentView: View {
    @StateObject var networkMonitor: NetworkMonitor = NetworkMonitor()
    @ObservedObject var userModel: UserModel = UserModel.shared

    var body: some View {
        ZStack {
            Color(hexString: "#000000")!
                .opacity(0.05)
                .ignoresSafeArea()
            VStack {
                HomeView(userModel: userModel)
                // TODO: ADD IN BOTTOM NAVIGATION BAR TO REPLACE HOMEVIEW
            }
            .environmentObject(networkMonitor)
            .onAppear {
                networkMonitor.startMonitoring()
            }
            .onDisappear {
                networkMonitor.stopMonitoring()
            }
            .task {
                await userModel.decodeFromLocal()
            }
            .ignoresSafeArea()
        }
    }

}

#Preview {
    ContentView()
}
