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
    @ObservedObject private var eventsModel: EventsModel = EventsModel()

    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            MCalendarView(selectedDate: $dateSelected, selectedRange: nil, configBuilder: configureCalendar)
                .task {
                    eventsModel.calendar = await eventsModel.decodeFromLocal()
                }
                .frame(height: 400)
                .padding(24)
// TODO: FUNCTIONALITY FOR ADMINISTRATOR TO ADD AND REMOVE EVENTS.
            Divider()
            HStack(spacing: 24) {
                Button {
                    print("Add Event")
                    addEvents()
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    Task {
                        print("record Event")
                        await decodeEvents()
                    }
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    Task {
                        print("Mock Events")
                        generateMockEvents()
                    }
                } label: {
                    Image(systemName: "plus")
                }
                Spacer()
                Button {
                    Task {
                        print("Encode to Database Events")
                        encodeToNetworkEvents()
                    }
                } label: {
                    Image(systemName: "plus")
                }
                Spacer()

                Button {
                    Task {
                        print("Decode from Database Events")
                        decodeFromNetworkEvents()
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            .frame(height: 15)
            Divider()
            createEventsView()
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
        guard let hasSavedEvents = eventsModel.calendar.dayEvents.first(
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
        EventsView(selectedDate: $dateSelected, events: $eventsModel.calendar.dayEvents)
            .padding(.horizontal, 24)
            .frame(minHeight: 240)
    }
    
    func configureCalendar(_ config: CalendarConfig) -> CalendarConfig {
        config
            .daysHorizontalSpacing(9)
            .daysVerticalSpacing(19)
            .monthsBottomPadding(16)
            .monthsTopPadding(20)
            .monthLabel { ML.Center(month: $0) }
            .dayView(buildDayView)
    }
    
    func addEvents() {
        guard let date = dateSelected else {
            print("addEvents: Failed to add event")
            return
        }
        
        DispatchQueue.main.async {
            eventsModel.calendar.dayEvents = eventsModel.addEvents(dateToEdit: date, [EventsModel.MockEvent()])
        }
        print(date)
    }

    func decodeEvents() async {
        guard let date = dateSelected else {
            print("addEvents: Failed to add event")
            return
        }
        print(date)
        eventsModel.calendar = await eventsModel.decodeFromLocal()
    }

    func generateMockEvents() {
        DispatchQueue.main.async {
            eventsModel.calendar = EventsModel.MockCreateEvents(3)
        }
    }

    func encodeToNetworkEvents() {
        eventsModel.encodeAndSendToDatabase()
    }

    func decodeFromNetworkEvents() {
        eventsModel.calendar = eventsModel.requestAndDecodeFromDatabase(limit: 1)
    }
}

#Preview {
    CalendarView()
}
