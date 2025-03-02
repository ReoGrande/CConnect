//
//  ContentView.swift
//  CConnect
//
//  Created by Reo Ogundare on 2/27/25.
//  Credits to: https://swiftpackageindex.com/AllanJuenemann/CalendarView
//

import SwiftUI
import SwiftData
import MijickCalendarView

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var date = DateComponents()
    let currentDate = Helpers.currentDateInDateComponents() // TODO: REMOVE MOCK INFO
    @State var dateSet : [DateComponents] = []
    @State var dateIsSelected : Bool = false
    @State var eventSelected: EventModel = EventModel.MockCreateEventModel(numberOfPeople: 3, date: Helpers.currentDateInDateComponents()) // TODO: REMOVE MOCK INFO
    var eventsList: Set<EventModel> = Helpers.MockBuildEventsList() // TODO: REMOVE MOCK INFO
    @State var EventDestination: AnyView? = nil
    
    
    var currentDayIndex : Int {
//        print(currentDate.day)
        return currentDate.day ?? 1
    }
    
    var body: some View {
  
            Section {
                    CalendarView(selection: $dateSet)
                        .decorating([DateComponents(day: currentDayIndex)]) {
                            Button("Tap") {
                                print("Button tapped")
                                dateIsSelected = true
                            }
                        }
                        .selectable { dateComponents in
                            dateComponents.day! >= currentDayIndex
                        }
            }.sheet(isPresented: $dateIsSelected) {
                if hasEventAtDate(selectedDate: dateSet.first!) {
                        EventView(Event: $eventSelected)
                    }
            }
        
        
        //            EventView(Event: $eventSelected)
    }
    
    private func hasEventAtDate( selectedDate: DateComponents) -> Bool {
        var hasDate = false
        eventsList.forEach { event in
            if event.date == selectedDate {
                hasDate = true
            }
        }
        return hasDate
    }
}

#Preview {
    ContentView(dateSet: [])
}
