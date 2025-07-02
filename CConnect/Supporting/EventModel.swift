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
struct EventsModel: Hashable {
    var events: [Date: [Event]] = [:]

    /*
     TODO: EventModel Rebuild
     - Handle Events (Done)
     - Addition and removal (Done)
     - Saving to Database
     - Retrieval to EventModel
     */

    /// Add `events` from `dateToEdit`
    mutating func addEvents(dateToEdit: Date, _ eventsToAdd: [Event]) {
        self.events[dateToEdit] = eventsToAdd
        // TODO: FIX UI FOR ADD EVENTS NOT RESPONDING
        print(" addEvents EventModel: \(events[dateToEdit])")
    }

    /// Removes `events` from `dateToEdit`
    mutating func removeEvents(dateToEdit: Date, _ eventsToRemove: [Event]) {
        var mutatingDate = events[dateToEdit]

        mutatingDate?.removeAll(where: { event in
            eventsToRemove.contains(event)
        })

        events[dateToEdit] = mutatingDate
    }

    /// Builds Mock Events from default setup
    static func MockCreateEventsModel() -> EventsModel {
        var eventsStore: [Date: [Event]] = [:]

        for i in 0...90 {
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
        return EventsModel(events: eventsStore)
    }

    static func MockEvent() -> Event {
        .init(name: "Vault Session", range: "06:30am - 08:30am", color: .blue)
    }
}
