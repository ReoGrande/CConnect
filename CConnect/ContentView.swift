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
    @State var date = DateComponents()
    let currentDate = DateComponents()
    @State var dateSet : [DateComponents] = []
    @State var dateSelected : Bool = true
    
    var currentDayIndex : Int {
        currentDate.day ?? 3
    }
    
    var body: some View {
        NavigationStack {
            Section {
                CalendarView(selection: $dateSet)
                    .decorating([DateComponents(day: currentDayIndex)]) {
                        Text("Date")
                    }
                    .selectable { dateComponents in
                        dateComponents.day! > currentDayIndex
                    }
                
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

#Preview {
    ContentView(dateSet: [])
}
