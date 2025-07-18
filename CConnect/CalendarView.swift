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
    @State private var dateSelected : Date? = CalendarView.dateNow()
    @StateObject var eventsModel: EventsModel
    @StateObject var settingsModel: SettingsViewModel
    @State private var adminSettingsShowing: Bool = false

    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            MCalendarView(selectedDate: $dateSelected, selectedRange: nil, configBuilder: configureCalendar)
                .frame(height: 400)
                .padding(24)
// TODO: FUNCTIONALITY FOR ADMINISTRATOR TO ADD(Default) AND REMOVE EVENTS.
            if settingsModel.currentMode == .admin {
                Divider()
                HStack {
                    Spacer()
                    Button {
                        print("Add Event")
                        addEvents()
                        print(dateSelected)
                    } label: { Text("Add Event") }
                        .buttonStyle(.bordered)

                    Spacer()
                    Button("Admin Settings") {
                        adminSettingsShowing = !adminSettingsShowing
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $adminSettingsShowing) {
                        AdminButtonView()
                    }

                    Spacer()
                }
            }
            Divider()
            createEventsView()
            Spacer()
        }
        .task {
            eventsModel.calendar = await eventsModel.decodeFromLocal()
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
            where: { $0.date.isSame(date) })?.day
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
        EventsView(selectedDate: $dateSelected, eventsModel: eventsModel, settingsModel: settingsModel)
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

    func deleteEvents() {
        guard let date = dateSelected else {
            print("deleteEvents: Failed to delete event")
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
        guard let date = dateSelected else {
            print("addEvents: Failed to add event")
            return
        }

        DispatchQueue.main.async {
            eventsModel.calendar = EventsModel.MockCreateEvents(startDate: date, 90)
        }
    }

    func encodeToNetworkEvents() {
        eventsModel.encodeAndSendToDatabase()
    }

    func decodeFromNetworkEvents()  {
        DispatchQueue.main.async {
            eventsModel.requestAndDecodeFromDatabase(limit: 1) { (retrievedEvents) in
                 if let events = retrievedEvents {
                     eventsModel.calendar = events
                     // Now you can use 'events' here! Update your UI, process the data, etc.
                 } else {
                     print("Failed to retrieve events or no events found on remote.")
                 }
             }
        }
    }

    static func dateNow() -> Date {
        let utzCal = Calendar(identifier: .gregorian)

        let year = utzCal.component(.year, from: Date())
        let month = utzCal.component(.month, from: Date())
        let day = utzCal.component(.day, from: Date())
        return DateComponents(calendar: utzCal, year: year, month: month, day: day).date!
    }
}

extension CalendarView {
    func AdminButtonView() -> some View {
        VStack {
            Spacer()
            List {
                Button {
                    Task {
                        print("record Events")
                        await decodeEvents()
                        adminSettingsShowing = !adminSettingsShowing
                    }
                } label: { Text("Retrieve all local events") }
                
                Button {
                    Task {
                        print("Mock Events")
                        generateMockEvents()
                        adminSettingsShowing = !adminSettingsShowing
                    }
                } label: { Text("Replace all events with default schedule") }
                Button {
                    Task {
                        print("Encode to Database Events")
                        encodeToNetworkEvents()
                        adminSettingsShowing = !adminSettingsShowing
                    }
                } label: { Text("Save schedule to server")}
                Button {
                    Task {
                        print("Decode from Database Events")
                        decodeFromNetworkEvents()
                        adminSettingsShowing = !adminSettingsShowing
                    }
                } label: { Text("Retrieve newest schedule from server") }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}

#Preview {
    CalendarView(eventsModel: EventsModel(), settingsModel: SettingsViewModel())
}
