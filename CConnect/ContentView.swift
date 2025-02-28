//
//  ContentView.swift
//  CConnect
//
//  Created by Reo Ogundare on 2/27/25.
//  Credits to: https://swiftpackageindex.com/AllanJuenemann/CalendarView
//

import SwiftUI
import SwiftData
import CalendarView

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var date = Date()
    @State var dateSet : Set<DateComponents> = []

    var body: some View {
        NavigationStack {
            Section {
                CalendarView()
                    .decorating([DateComponents(day: 16)]) {
                        Text("Day")
                    }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
        
}

#Preview {
    ContentView()
}
