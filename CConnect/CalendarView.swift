//
//  CalendarView.swift
//  CConnect
//
//  Created by Reo Ogundare on 3/2/25.
//  Credits to: https://swiftpackageindex.com/AllanJuenemann/CalendarView,
//  https://github.com/Mijick/CalendarView
//

import SwiftUI
import SwiftData
import MijickCalendarView

struct CalendarView: View {
    @State private var dateRange : MDateRange? = .init()
    @State private var dateSelected : Date? = Date.now
    private let events: [Date: [Event]] = .init()
    
    var body: some View {
            VStack {
                MCalendarView(selectedDate: $dateSelected, selectedRange: nil, configBuilder: configureCalendar)
                    .padding(.horizontal, 24)
                Spacer()
                createEventsView()
                .padding(.horizontal, 24)
                Spacer()
        }
            .navigationTitle("BPVA Calendar")
    }
}

extension CalendarView {

    func buildDayView(_ date: Date, _ isCurrentMonth: Bool, selectedDate: Binding<Date?>?, range: Binding<MDateRange?>?) -> DV.ColoredCircle {
        return .init(date: date, color: getDateColor(date), isCurrentMonth: isCurrentMonth, selectedDate: selectedDate, selectedRange: nil)
    }

    func getDateColor(_ date: Date) -> Color? {
        guard let hasSavedEvents = events.first(where: { $0.key.isSame(date) })?.value else { return nil }
        print(events)

        switch hasSavedEvents.count{
        case 1:
            return .red
        case 2...5:
            return .gray
        case 6...Int.max:
            return .blue
        default:
            return nil
        }
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

// MARK: Helper + Mock Events store
fileprivate extension [Date: [CalendarView.Event]] {
    init() {
        
        var eventsStore: [Date: [CalendarView.Event]] = [:]
        
        for i in 0...90 {
            let currentDay = Date.now.add(i, .day)
            let dayDescription = MDateFormatter.getString(from: currentDay, format: "EEE")
            if DayType.isWeekDay(day: dayDescription)  {
                // Build class times
                let eventsForDay: [CalendarView.Event] = [
                    .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: .red),
                    .init(name: "Lift", range: "05:30pm - 06:30pm", color: .black),
                    .init(name: "Vault Session #1", range: "06:30pm - 08:30pm", color: .red)
                ]
                eventsStore[currentDay] = eventsForDay
            } else if DayType(rawValue: dayDescription) == .Sat {
                // Build meet times
                let eventsForDay: [CalendarView.Event] = [ .init(name: "Vault Competition", range: "10:00am - 5:00pm", color: .red) ]
                eventsStore[currentDay] = eventsForDay
            }
        }
        self = eventsStore
    }
}

#Preview {
    CalendarView()
}
