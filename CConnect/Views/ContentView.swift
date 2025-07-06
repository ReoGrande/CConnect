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
    var body: some View {
        VStack {
            Spacer()
            NavigationStack {
                HomeView()
            }
            Spacer()
// TODO: ADD IN BOTTOM NAVIGATION BAR TO REPLACE HOMEVIEW
//            Color.black
//                .frame(minWidth: 0, maxWidth: .infinity)
//                .frame(height: 100)
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    ContentView()
}
