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
                        CalendarView()
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
                        Text("Settings")
                    } label: {
                        Text("Settings")
                    }
                    Spacer()
                }
                Spacer()
            }
        .frame(minHeight: 25, maxHeight: 50)
}
        
    }
}

#Preview {
    HomeView()
}

