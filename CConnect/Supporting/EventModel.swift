//
//  EventModel.swift
//  CConnect
//
//  Created by Reo Ogundare on 3/2/25.
//

import SwiftUI

struct Event: Equatable, Hashable {
    let name: String
    let range: String
    let color: Color
}

/// `Model` responsible for storing and mutating `Events`
class EventsModel {
    var events: [Date: [Event]]

    /*
     TODO: EventModel Rebuild
     - Handle Events (Done)
     - Addition and removal (Done)
     - Saving to Database
     - Retrieval to EventModel
     */
    init(events: [Date : [Event]]) {
        self.events = events
    }

    init() {
        // TODO: MAKE A GENERATED DEFAULTS JSON, RENAME MOCKCREATEEVENTS TO
        // DefaultEvents
        self.events = EventsModel.MockCreateEvents()
    }

    /// Add `events` from `dateToEdit`
    func addEvents(dateToEdit: Date, _ eventsToAdd: [Event]) -> [Date:[Event]] {
        let dateToEditString = MDateFormatter.getString(from: dateToEdit, format: "d MMM y")
        print("****DATETOEDITv\(dateToEditString)")
        var ev: Date? = nil

        events.keys.forEach { date in
            if MDateFormatter.getString(from: date, format: "d MMM y") == dateToEditString {
                print("\(date)")
                print(" before addEvents EventModel: \(String(describing: events[date]))")
                ev = date
                // TODO: FIX UI FOR ADD EVENTS NOT RESPONDING
                print(" addEvents EventModel: \(String(describing: events[date]))")
            }
        }

        guard let ev else {
            events[dateToEdit] = eventsToAdd
            return events
        }

        events[ev]?.append(contentsOf: eventsToAdd)
        return events
    }

    /// Removes `events` from `dateToEdit`
    func removeEvents(dateToEdit: Date, _ eventsToRemove: [Event]) {
        var mutatingDate = events[dateToEdit]

        mutatingDate?.removeAll(where: { event in
            eventsToRemove.contains(event)
        })

        events[dateToEdit] = mutatingDate
    }

    /// Builds Mock Events
    static func MockCreateEvents() -> [Date: [Event]] {
        var eventsStore: [Date: [Event]] = [:]

        for i in 0...2 {
            let currentDay = Date.now.add(i, .day)
            let dayDescription = MDateFormatter.getString(from: currentDay, format: "EEE")
            if DayType.isWeekDay(day: dayDescription)  {
                // Build class times
                let eventsForDay: [Event] = [
                    .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: .red),
                    .init(name: "Lift", range: "05:30pm - 06:30pm", color: .black),
                    .init(name: "Vault Session #1", range: "06:30pm - 08:30pm", color: .red)
                ]
                eventsStore[currentDay] = eventsForDay
            } else if DayType(rawValue: dayDescription) == .Sat {
                // Build meet times
                let eventsForDay: [Event] = [ .init(name: "Vault Competition", range: "10:00am - 5:00pm", color: .red) ]
                eventsStore[currentDay] = eventsForDay
            }
        }
        return eventsStore
    }

    /// Builds Mock Events from default setup
    static func MockCreateEventsModel() -> EventsModel {
        EventsModel(events: MockCreateEvents())
    }

    static func MockEvent() -> Event {
        let rand = Int.random(in: 0...9)
        let colors: [Color] = [.blue, .green, .red, .orange, .gray, .yellow, .white, .cyan, .mint, .pink]
        return .init(name: String(Int.random(in: 0...1000)), range: "0\(rand):30am - 0\(rand + 1):30am", color: colors[rand])
    }
}
