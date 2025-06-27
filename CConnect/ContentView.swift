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
    @State private var dateRange : MDateRange? = .init()
    @State private var dateSelected : Date? = Date.now
    private let events: [Date: [Event]] = .init()
    
    var body: some View {
            
        NavigationStack {
            VStack {
                MCalendarView(selectedDate: $dateSelected, selectedRange: nil, configBuilder: configureCalendar)
                    .padding(.horizontal, 24)
                Spacer()
                createEventsView()
                .padding(.horizontal, 24)
                Spacer()
                
// //MARK: TOOLBAR FOR REUSE
//                Color.secondary
//                    .opacity(0.4)
//                    .ignoresSafeArea()
//                    .overlay(
//                HStack {
//                    NavigationLink {
//                        Text("Announcements")
//                    } label: {
//                        Text("Announcements")
//                    }
//                    Button("Visit BPVA Online") {
//                        openURL(URL(string: "https://www.buckeyepolevaultacademy.com/")!)
//                    }
//                    NavigationLink {
//                        Text("Settings")
//                    } label: {
//                        Text("Settings")
//                    }
//                }
//                )
//            
//            .frame(minHeight: 25, maxHeight: 50)
        }
            .navigationTitle("BPVA Calendar")
        }
    }
}

extension ContentView {
    struct Event: Equatable, Hashable {
        let name: String
        let range: String
        let color: Color
    }

    func buildDayView(_ date: Date, _ isCurrentMonth: Bool, selectedDate: Binding<Date?>?, range: Binding<MDateRange?>?) -> DV.ColoredCircle {
        return .init(date: date, color: getDateColor(date), isCurrentMonth: isCurrentMonth, selectedDate: selectedDate, selectedRange: nil)
    }

    func getDateColor(_ date: Date) -> Color? {
       let hasSavedEvents = events.first(where: { $0.key.isSame(date) }) != nil
        print(events)
        return hasSavedEvents ? .gray : nil
    }

    func createEventsView() -> some View {
        EventsView(selectedDate: $dateSelected, events: events)
            .padding(24)
            .frame(height: 200)
    }

    func configureCalendar(_ config: CalendarConfig) -> CalendarConfig {
        config
            .daysHorizontalSpacing(9)
            .daysVerticalSpacing(19)
            .monthsBottomPadding(16)
            .monthsTopPadding(42)
            .monthLabel { ML.Center(month: $0) }
            .dayView(buildDayView)

    }
}

// MARK: Helpers
fileprivate extension [Date: [ContentView.Event]] {
    init() {
        let events1: [ContentView.Event] = [
            .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: .red),
            .init(name: "Lift", range: "05:30pm - 06:30pm", color: .black),
            .init(name: "Vault Session #1", range: "06:30pm - 08:30pm", color: .red)
        ]
        let events2: [ContentView.Event] = [
            .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: .red),
            .init(name: "Lift", range: "05:30pm - 06:30pm", color: .black),
            .init(name: "Vault Session #1", range: "06:30pm - 08:30pm", color: .red)
        ]
        let events3: [ContentView.Event] = [ .init(name: "Vault Competition", range: "10:00am - 5:00pm", color: .red) ]
        
        self = [ Date.now: events1, Date.now.add(1, .day): events2, Date.now.add(2, .day): events3 ]
    }
}

#Preview {
    ContentView()
}
