//
//  EventsView.swift
//  CConnect
//
//  Created by Reo Ogundare on 6/26/25.
//

import SwiftUI

extension CalendarView {
    struct EventsView: View {
        @Binding var selectedDate: Date?
        @State var modifyShowing: Bool = false
        @StateObject var eventsModel: EventsModel
        @StateObject var settingsModel: SettingsViewModel
        @State var modifiedEventName: String = ""
        @State var modifiedEventColor: String = "#FFFFFF"
        @State var eventSelected: Event?
        @StateObject var selectedRange: TimePickerModel = TimePickerModel()
        @State private var selectedAP1Index = 0
        @State private var selectedAP2Index = 0
        @State private var selectedEventAttendees: [User] = []
        

        

        var body: some View {
            VStack() {
                createTitle()
                createContent()
                Spacer()
            }
        }
    }
}

private extension CalendarView.EventsView {
    func createTitle() -> some View {
        Text(title)
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    @ViewBuilder func createContent() -> some View {
        switch eventsModel.calendar.dayEvents.first(where: { dayEvents in
            dayEvents.date == selectedDate
        }) {
            case .some(let events):
            createEventsList(events)
            case .none:
            
            EmptyView()
        }
    }
}

//TODO: SEPARATE INTO A EVENTSLISTVIEW
private extension CalendarView.EventsView {
    func createEventsList(_ events: DayEvents) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(events.day, id: \.id) { event in
                    HStack(spacing: 10) {
                        createColoredIndicator(event)

                        NavigationLink {
                            createEventDetailView(event: event)
                                .task {
                                    decodeFromNetworkEvents()
                                }
                        } label: {
                            VStack(spacing: 4) {
                                createEventTitle(event)
                                createEventSubtitle(event)
                            }
                        }
                        .buttonStyle(.bordered)
                        if settingsModel.currentMode == .admin {
                            VStack {
                                Button("Modify") {
                                    eventSelected = event
                                    modifyShowing = !modifyShowing
                                    print("Modify")
                                }
                                .buttonStyle(.bordered)
                                if let eventS = eventSelected {
                                    Spacer()
                                        .sheet(isPresented: $modifyShowing) {
                                            createModifyEventsView(day: events.date,eventToModify: eventS)
                                                .onDisappear {
                                                    eventSelected = nil
                                                }
                                        }
                                } else {
                                    Spacer()
                                }
                                Button("Delete") {
                                    deleteEvent(day: events.date, event: event)
                                    print("Delete")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
            }
        }
    }

    func deleteEvent(day: Date, event: Event) {
        eventsModel.calendar.deleteEvent(day: day, event: event)
    }

    func createElement(_ event: Event) -> some View {
        HStack(spacing: 10) {
            createColoredIndicator(event)
            
            VStack(spacing: 4) {
                createEventTitle(event)
                createEventSubtitle(event)
            }
        }
    }

    func populateAttendees(day: Date, event: Event) {
        eventsModel.calendar.setAttendeesForDayEvent(day: day, event: event)
        selectedEventAttendees = event.attendees
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
}
// MARK: Event UI
private extension CalendarView.EventsView {
    func createColoredIndicator(_ event: Event) -> some View  {
        RoundedRectangle(cornerRadius: 3)
            .fill(event.color)
            .frame(width: 6, height: 20)
    }
    func createEventTitle(_ event: Event) -> some View {
        Text(event.name)
            .font(.body)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func createEventSubtitle(_ event: Event) -> some View {
        Text(event.range)
            .font(.body)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
private extension CalendarView.EventsView {
    var title: String {
        guard let selectedDate else { return "" }
        if CalendarView.dateNow().isSame(selectedDate) { return "TODAY" }
        else { return day.uppercased() }
    }
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: selectedDate ?? Date())
    }
}

private extension CalendarView.EventsView {
    func createModifyEventsView(day: Date, eventToModify: Event) -> some View {
        VStack(alignment: .center, spacing: 25) {
            HStack(spacing: 25) {
                Button("Cancel") {
                    modifyShowing = !modifyShowing
                }
                Spacer()
            }
            VStack {
                Text("Modify: ")
                    .bold()
                Text("\(eventToModify.name), \(eventToModify.range)")
            }
            Divider()
            HStack(spacing: 25) {
                Spacer()
                VStack {
                    TextField(eventToModify.name, text: $modifiedEventName)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
            }
            .background(.ultraThinMaterial)

            VStack {
                Text(updateRangeFromPicker())
                    .background(.ultraThinMaterial)

                createTimePicker()
            }

            Divider()
            Picker("Event Color: ", selection: $modifiedEventColor) {
                ForEach(Helpers.colors.sorted(by: >), id: \.key) { key, value  in
                    Text("\(value)")
                }
            }
            .pickerStyle(.wheel)
            .background(.ultraThinMaterial)
            Spacer()
            Divider()
            Button("Submit") {
                // Can return with unedited element if all are empty
                if !modifiedEventName.isEmpty {
                    let modified = Event(id: eventToModify.id, name: modifiedEventName, range: selectedRange.totalRange, color: modifiedEventColor, date: day, attendees: eventToModify.attendees)
                    modifyEvent(day: day, event: eventToModify, modified: modified)
                } else if modifiedEventColor != eventToModify.color.toHex() {
                    modifyEvent(day: day, event: eventToModify, modified: Event(id: eventToModify.id, name: eventToModify.name, range: eventToModify.range, color: modifiedEventColor, date: day, attendees: eventToModify.attendees))
                }

                modifiedEventName = ""
                resetRangeFromPicker()
                modifiedEventColor = ""

                modifyShowing = !modifyShowing
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(25)
    }

    func modifyEvent(day: Date, event: Event, modified: Event) {
        eventsModel.calendar.modifyEvent(day: day, eventToModify: event, modifiedEvent: modified)
    }

    func createTimePicker() -> some View {
        HStack {
            Picker("", selection: $selectedRange.startTime.hour){
                ForEach(1..<13, id: \.self) { i in
                    Text("\(i)").tag(i)
                        .fixedSize(horizontal: true, vertical: false)

                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: $selectedRange.startTime.minute){
                ForEach(minutesP, id: \.self) { i in
                    Text("\(i < 10 ? "0\(i)" : "\(i)")").tag(i)
                        .fixedSize(horizontal: true, vertical: false)

                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: $selectedRange.startTime.apSelected){
                ForEach(AMPM, id: \.self) { i in
                    Text("\(i)")
                        .fixedSize(horizontal: true, vertical: false)
                }
            }.pickerStyle(WheelPickerStyle())
            
            Divider()
            
            Picker("", selection: $selectedRange.endTime.hour){
                ForEach(1..<13, id: \.self) { i in
                    Text("\(i)").tag(i)
                        .fixedSize(horizontal: true, vertical: false)

                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: $selectedRange.endTime.minute){
                ForEach(minutesP, id: \.self) { i in
                    Text("\(i < 10 ? "0\(i)" : "\(i)")").tag(i)
                        .fixedSize(horizontal: true, vertical: false)

                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: $selectedRange.endTime.apSelected){
                ForEach(AMPM, id: \.self) { i in
                    Text("\(i)")
                        .fixedSize(horizontal: true, vertical: false)
                }
            }.pickerStyle(WheelPickerStyle())
}.padding(.horizontal)
    }

    func updateRangeFromPicker() -> String {
        let tempString = selectedRange.totalRange

        return tempString
    }

    private func updateStartTimeAP(_ ap: String) {
        selectedRange.startTime.apSelected = ap
    }

    private func updateEndTimeAP(_ ap: String) {
        selectedRange.endTime.apSelected = ap
    }
    func resetRangeFromPicker() {
        selectedRange.startTime = TimeModel()
        selectedRange.endTime = TimeModel()
    }
}

// MARK: Helpers
fileprivate extension [Date: [Event]] {
    subscript(_ key: Date?) -> [Event]? {
        guard let key else { return nil }
        return self.first(where: { $0.key.isSame(key) })?.value
    }
}

private let minutesP: [Int] = [0, 15, 30, 45]
