//
//  EventModel.swift
//  CConnect
//
//  Created by Reo Ogundare on 3/2/25.
//

/**REFERENCE FOR JSON RETRIEVAL AND SAVING WHEN SERVER IS OPENED: https://stackoverflow.com/questions/50790702/how-do-i-make-json-data-persistent-for-offline-use-swift-4
 **/

import SwiftUI

struct Event: Equatable, Hashable, Codable {
    let name: String
    let range: String
    let color: Color
// TODO: ATTENDEE TYPE
//    var attendees: Attendee

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case range = "range"
        case color = "color"
    }

    init(name: String, range: String, color: String) {
        self.name = name
        self.range = range
        self.color = Color(hexString: color) ?? Color.white
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.range = try container.decode(String.self, forKey: .range)

        let tempColor = try container.decode(String.self, forKey: .color)
        self.color = Color(hexString: tempColor) ?? Color.white
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.range, forKey: .range)
        try container.encode(self.color.description, forKey: .color)
    }
}

struct Events: Codable {
    var dayEvents: [Date:[Event]]
}


/// `Model` responsible for storing and mutating `Events`
class EventsModel: ObservableObject {
    @Published var calendar: Events {
        didSet {
            do {
                if calendar.dayEvents.count > 0 {
                    try encodeToLocal()
                }
            } catch {
                print("Cannot encode to local")
            }
        }
    }

    /*
     TODO: EventModel Rebuild
     - Handle Events (Done)
     - Addition and removal (Done)
     - Saving to Database
     - Retrieval to EventModel
     */
    init(events: Events) {
        self.calendar = events
    }

    init() {
        // DefaultEvents
        self.calendar = Events(dayEvents: [:])
    }

    /// Add `events` from `dateToEdit`
    func addEvents(dateToEdit: Date, _ eventsToAdd: [Event]) -> [Date:[Event]] {
        let dateToEditString = MDateFormatter.getString(from: dateToEdit, format: "d MMM y")
//        print("****DATETOEDITv\(dateToEditString)")
        var ev: Date? = nil

        calendar.dayEvents.forEach { date in
            if MDateFormatter.getString(from: date.key, format: "d MMM y") == dateToEditString {
//                print("\(date.key)")
//                print(" before addEvents EventModel: \(String(describing: calendar.dayEvents[date.key]))")
                ev = date.key
                // TODO: FIX UI FOR ADD EVENTS NOT RESPONDING
//                print(" addEvents EventModel: \(String(describing: calendar.dayEvents[date.key]))")
            }
        }

        guard let ev else {
            calendar.dayEvents[dateToEdit] = eventsToAdd
            return calendar.dayEvents
        }

        calendar.dayEvents[ev]?.append(contentsOf: eventsToAdd)
        return calendar.dayEvents
    }

    /// Removes `events` from `dateToEdit`
    func removeEvents(dateToEdit: Date, _ eventsToRemove: [Event]) {
        var mutatingDate = calendar.dayEvents[dateToEdit]

        mutatingDate?.removeAll(where: { event in
            eventsToRemove.contains(event)
        })

        calendar.dayEvents[dateToEdit] = mutatingDate
    }

    // MARK: Mock Events
    /// Builds Mock Events
    static func MockCreateEvents(_ days: Int) -> Events {
        var eventsStore: [Date: [Event]] = [:]

        for i in 0...days {
            let currentDay = Date.now.add(i, .day)
            let dayDescription = MDateFormatter.getString(from: currentDay, format: "EEE")
            if DayType.isWeekDay(day: dayDescription)  {
                // Build class times
                let eventsForDay: [Event] = [
                    .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: "#FF0000"),
                    .init(name: "Lift", range: "05:30pm - 06:30pm", color: "#000000"),
                    .init(name: "Vault Session #1", range: "06:30pm - 08:30pm", color: "#FF0000")
                ]
                eventsStore[currentDay] = eventsForDay
            } else if DayType(rawValue: dayDescription) == .Sat {
                // Build meet times
                let eventsForDay: [Event] = [ .init(name: "Vault Competition", range: "10:00am - 5:00pm", color: "#FF0000") ]
                eventsStore[currentDay] = eventsForDay
            }
        }
        return Events(dayEvents: eventsStore)
    }

    /// Builds Mock Events from default setup
    static func MockCreateEventsModel() -> EventsModel {
        EventsModel(events: MockCreateEvents(30))
    }

    static func MockEvent() -> Event {
        let rand = Int.random(in: 0...9)
        let colors: [String] = ["#000000", "#FF0000", "#FFA500", "#808080", "#FFFF00", "#FFFFFF", "#0000FF", "#FFC0CB", "#FFF8DC", "#90EE90"]
        return .init(name: String(Int.random(in: 0...1000)), range: "0\(rand):30am - 0\(rand + 1):30am", color: colors[rand])
    }

    static func EmptyEvents() -> Events {
        return Events(dayEvents: [:])
    }
}

extension EventsModel {
    func encodeToLocal() throws {
        let jsonEncoder = JSONEncoder()
        let eventsJson = try jsonEncoder.encode(calendar)
        guard let bookJsonString = String(data: eventsJson, encoding: .utf8) else {
            print("JSON Failed to convert to string")
            return
        }
        //print("\(bookJsonString)")
        let url = URL.documentsDirectory.appending(path: "Events.txt")

        do {
            try eventsJson.write(to: url, options: [.atomic, .completeFileProtection])
            let input = try String(contentsOf: url, encoding: .utf8)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }

    func decodeFromLocal() async -> Events {
        let url = URL.documentsDirectory.appending(path: "Events.txt")
        let decoder = JSONDecoder()
        do {
            let input = try String(contentsOf: url, encoding: .utf8)
            let (data, _) = try await URLSession.shared.data(from: url)
            let calendarData = try decoder.decode(Events.self, from: data)
            print("****Calendar: \(calendarData)")

            return calendarData
        } catch {
            print(error.localizedDescription)
        }

        return Events(dayEvents: [:])
    }

}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
