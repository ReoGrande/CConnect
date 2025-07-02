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

/// Builds view for `MKCalendar`
struct CalendarView: View {
    @State private var dateRange : MDateRange? = .init()
    @State private var dateSelected : Date? = Date.now
    private let eventsModel: EventsModel = EventsModel.MockCreateEventsModel()
    
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
        guard let hasSavedEvents = eventsModel.events.first(
                    where: { $0.key.isSame(date) })?.value
        else { return nil }

//        print("\(date.description) events: \(hasSavedEvents)")

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
        EventsView(selectedDate: $dateSelected, events: eventsModel.events)
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

#Preview {
    CalendarView()
}
