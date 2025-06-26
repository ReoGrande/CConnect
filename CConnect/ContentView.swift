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
    @Environment(\.openURL) var openURL
    @Environment(\.modelContext) private var modelContext
    @State var dateRange : MDateRange? = .init()
    @State var dateSelected : Date? = nil
    
    var body: some View {
            
        NavigationStack {
            VStack {
                HStack {
                    
                }
            MCalendarView(selectedDate: $dateSelected, selectedRange: $dateRange) {
                $0
                                (...)
                                .dayView(NewDayView)
                                .firstWeekday(.wednesday)
                                .monthLabelToDaysDistance(12)
                                .weekdaysView(NewWeekdaysView.init)
                                (...)
            }
                Color.secondary
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .overlay(
                HStack {
                    NavigationLink {
                        Text("Announcements")
                    } label: {
                        Text("Announcements")
                    }
                    Button("Visit BPVA Online") {
                        openURL(URL(string: "https://www.buckeyepolevaultacademy.com/")!)
                    }
                    NavigationLink {
                        Text("Settings")
                    } label: {
                        Text("Settings")
                    }
                }
                )
            
            .frame(minHeight: 25, maxHeight: 50)
        }
            .navigationTitle("BPVA Calendar")
        }
    }
}

#Preview {
    ContentView()
}
