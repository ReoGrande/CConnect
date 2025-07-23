//
//  EventModel.swift
//  CConnect
//
//  Created by Reo Ogundare on 3/2/25.
//

/**REFERENCE FOR JSON RETRIEVAL AND SAVING WHEN SERVER IS OPENED: https://stackoverflow.com/questions/50790702/how-do-i-make-json-data-persistent-for-offline-use-swift-4
 **/

import SwiftUI
import FirebaseDatabase

struct Event: Equatable, Hashable, Codable {
    let id: UUID
    let name: String
    let range: String
    let color: Color
    let date: Date
    var attendees: [User]
    // TODO: ATTENDEE TYPE
    //    var attendees: Attendee
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case range = "range"
        case color = "color"
        case date = "date"
        case attendees = "attendees"
    }

    init() {
        self.id = UUID()
        self.name = ""
        self.range = ""
        self.color = Color.white
        self.date = Date.now
        self.attendees = []
    }

    init(id: UUID = UUID(), name: String, range: String, color: String, date: Date = Date.now, attendees: [User] = []) {
        self.id = id
        self.name = name
        self.range = range
        self.color = Color(hexString: color) ?? Color.white
        self.date = date
        self.attendees = attendees
    }

    init(id: UUID = UUID(), name: String, range: String, color: Color, date: Date = Date.now, attendees: [User] = []) {
        self.id = id
        self.name = name
        self.range = range
        self.color = color
        self.date = date
        self.attendees = attendees
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.range = try container.decode(String.self, forKey: .range)
        
        let tempColor = try container.decode(String.self, forKey: .color)
        self.color = Color(hexString: tempColor) ?? Color.white

        let dateInterval = try container.decode(Double.self, forKey: .date)

        self.date = Date(timeIntervalSinceReferenceDate: dateInterval)

        self.attendees = try container.decode([User].self, forKey: .attendees)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.range, forKey: .range)
        try container.encode(self.color.description, forKey: .color)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.attendees, forKey: .attendees)
    }

    // TODO: INTEGRATE WITH CLOUD STORAGE FOR PULLING INFORMATION
    // WILL BE TRANSITIONED TO ASYNC FOR NETWORK CALLS
    func getAttendees() -> [User] {
        Helpers.mockAttendeesUsers.filter { user in
            user.attendanceHistory.contains(where: { eventID in
                eventID == self.id
            })
        }
    }

    mutating func setAttendees(attendees: [User]) {
        self.attendees = attendees
    }

    mutating func addAttendee(attendee: User) {
        self.attendees.append(attendee)
    }

    mutating func removeAttendee(attendee: User) {
        self.attendees.removeAll { user in
            user.id == attendee.id
        }
    }
}

struct DayEvents: Codable {
    var date: Date
    var day: [Event]

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case day = "day"
    }

    init(date: Date, day: [Event]) {
        self.date = date
        self.day = day
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateInterval = try container.decode(Double.self, forKey: .date)

        self.date = Date(timeIntervalSinceReferenceDate: dateInterval)
        self.day = try container.decode([Event].self, forKey: .day)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.day, forKey: .day)
    }

    /// Returns  event index if found
    func eventIndex(event: Event) -> Int? {
        day.firstIndex { testE in
            testE.id == event.id
        }
    }
    
    //NOTES: CHECKING THE WRONG EVENT, CHECKING VAULT SESSION 1 WHEN SHOLD BE CHECKING THE NEWEST EVENT

    /// Deletes event if found
    mutating func deleteEvent(event: Event) {
        guard let indexToDelete = eventIndex(event: event) else { return }
        day.remove(at: indexToDelete)
    }

    /// Modifies event if found, otherwise adds event
    mutating func modifyEvent(event: Event, replacement: Event) {
        guard let indexToReplace = eventIndex(event: event) else { return }
        day[indexToReplace] = replacement
    }

    mutating func setAttendeesForEvent(event: Event, attendees: [User]) {
        let newEvent = Event(id: event.id, name: event.name, range: event.range, color: event.color, date: event.date, attendees: attendees)
        modifyEvent(event: event, replacement: newEvent)
    }

    mutating func setAttendeesForAllEvents() {
        day.forEach { event in
            let attendees = event.getAttendees()
            setAttendeesForEvent(event: event, attendees: attendees)
        }
    }
}

struct Events: Codable {
    var saveTime: Date
    var dayEvents: [DayEvents]
    
    enum CodingKeys: String, CodingKey {
        case saveTime = "saveTime"
        case dayEvents = "dayEvents"
    }
    
    init(saveTime: Date, dayEvents: [DayEvents]) {
        self.saveTime = saveTime
        self.dayEvents = dayEvents
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.saveTime = try container.decode(Date.self, forKey: .saveTime)
        self.dayEvents = try container.decode([DayEvents].self, forKey: .dayEvents)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.saveTime, forKey: .saveTime)
        try container.encode(self.dayEvents, forKey: .dayEvents)
    }

    mutating func deleteEvent(day: Date, event: Event) {
        for index in dayEvents.indices {
            if day == dayEvents[index].date {
                dayEvents[index].deleteEvent(event: event)
                break
            }
        }
    }

    mutating func modifyEvent(day: Date, eventToModify: Event, modifiedEvent: Event) {
        let dateToEditString = MDateFormatter.getString(from: day, format: "d MMM y")

        for index in dayEvents.indices {
            if MDateFormatter.getString(from: dayEvents[index].date, format: "d MMM y") == dateToEditString {
                dayEvents[index].modifyEvent(event: eventToModify, replacement: modifiedEvent)
                break
            }
        }
    }

    mutating func setAttendeesForDayEvent(day: Date, event: Event) {
        for index in dayEvents.indices {
            if day == dayEvents[index].date {
                dayEvents[index].setAttendeesForAllEvents()
                break
            }
        }
    }
}


/// `Model` responsible for storing and mutating `Events`
class EventsModel: ObservableObject {
    @Published var calendar: Events {
        didSet {
            do {
                if calendar.dayEvents.count > 0 {
                    try encodeToLocal()
                    encodeAndSendToDatabase()
                }
            } catch {
                print("Cannot encode to local")
            }
        }
    }
    
    var ref: DatabaseReference
    var _refHandle: DatabaseHandle?
    
    /*
     TODO: EventModel Rebuild
     - Handle Events (Done)
     - Addition and removal (Done)
     - Saving to Database
     - Retrieval to EventModel
     */
    init(events: Events) {
        self.calendar = events
        self.ref = Database.database(url: "https://cconnect-3d3bc-default-rtdb.firebaseio.com/").reference()
    }
    
    init() {
        // DefaultEvents
        self.calendar = Events(saveTime: Date.now,dayEvents: [])
        self.ref = Database.database().reference()
    }
    
    deinit {
        if let handle = _refHandle {
            ref.child("posts").removeObserver(withHandle: handle)
            print("Observer removed for most recent posts.")
        }
    }

    /// Add `events` from `dateToEdit`
    func addEvents(dateToEdit: Date, _ eventsToAdd: [Event]) -> [DayEvents] {
        let dateToEditString = MDateFormatter.getString(from: dateToEdit, format: "d MMM y")
        var ev: Date? = nil
        var dateIndex = -1
        
        for (index, date) in calendar.dayEvents.enumerated() {
            if MDateFormatter.getString(from: date.date, format: "d MMM y") == dateToEditString {
                ev = date.date
                dateIndex = index
            }
        }
        
        guard ev != nil else {
            calendar.dayEvents.append(DayEvents(date: dateToEdit, day: eventsToAdd))
            return calendar.dayEvents
        }
        
        calendar.dayEvents[dateIndex].day.append(contentsOf: eventsToAdd)
        return calendar.dayEvents
    }
    
    // Deletes `events` from `dateToEdit`
    func deleteEvents(dateToEdit: Date, _ eventsToRemove: [Event]) -> [DayEvents] {
        let dateToEditString = MDateFormatter.getString(from: dateToEdit, format: "d MMM y")
        var ev: Date? = nil
        var dateIndex = -1

        for (index, date) in calendar.dayEvents.enumerated() {
            if MDateFormatter.getString(from: date.date, format: "d MMM y") == dateToEditString {
                ev = date.date
                dateIndex = index
            }
        }

        guard ev != nil else {
//            calendar.dayEvents.append(DayEvents(date: dateToEdit, day: eventsToAdd))
            calendar.dayEvents[dateIndex].day.removeAll(where: { event in
                eventsToRemove.contains(event)
            })
            return calendar.dayEvents
        }

        return calendar.dayEvents
    }
    
    // MARK: Mock Events
    /// Builds Mock Events
    // TODO: FORCE ALWAYS START FROM CURRENT DATE
    static func MockCreateEvents(startDate: Date, _ days: Int) -> Events {
        var eventsStore: [DayEvents] = []
        let actualDays = days - 1
        
        for i in 0...actualDays {
            let currentDay = startDate.add(i, .day)
            let dayDescription = MDateFormatter.getString(from: currentDay, format: "EEE")
            if DayType.isWeekDay(day: dayDescription)  {
                // Build class times
                let eventsForDay: [Event] = [
                    .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: "#CD2504"),
                    .init(name: "Lift", range: "05:30pm - 06:30pm", color: "#000000"),
                    .init(name: "Vault Session #2", range: "06:30pm - 08:30pm", color: "#CD2504")
                ]
                eventsStore.append(DayEvents(date: currentDay, day: eventsForDay))
            } else if DayType(rawValue: dayDescription) == .Sat {
                // Build meet times
                let eventsForDay: [Event] = [ .init(name: "Vault Competition", range: "10:00am - 5:00pm", color: "#CD2504") ]
                eventsStore.append(DayEvents(date: currentDay, day: eventsForDay))
            }
        }
        
        return Events(saveTime: Date.now, dayEvents: eventsStore)
    }
    
    /// Builds Mock Events from default setup
//    static func MockCreateEventsModel() -> EventsModel {
//        EventsModel(events: MockCreateEvents(30))
//    }

    static func EmptyEventsModel() -> EventsModel {
        EventsModel(events: EmptyEvents())
    }
    
    static func MockEvent(date: Date = Date.now) -> Event {
        let rand = Int.random(in: 0...9)
        let colors: [String:String] = Helpers.colors
        var tempEvent = Event(name: String(Int.random(in: 0...1000)), range: "0\(rand):30am - 0\(rand + 1):30am", color: colors.randomElement()?.key ?? "#FFFFFF", date: date)

        let count = Helpers.mockAttendeesUsers.count - 1

        for _ in 0..<Int.random(in: 0...3) {
            var attendee = Helpers.mockAttendeesUsers[Int.random(in: 0...count)]
            attendee.attendanceHistory.append(tempEvent.id)
            tempEvent.attendees.append(attendee)
        }
        return tempEvent
    }
    
    static func EmptyEvents() -> Events {
        return Events(saveTime: Date.now, dayEvents: [])
    }
}

// MARK: Local Encoding/Decoding
extension EventsModel {
    func encodeToLocal() throws {
        let jsonEncoder = JSONEncoder()
        let eventsJson = try jsonEncoder.encode(calendar)

        let url = URL.documentsDirectory.appending(path: "Events.txt")
        
        do {
            try eventsJson.write(to: url, options: [.atomic, .completeFileProtection])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func decodeFromLocal() async -> Events {
        let url = URL.documentsDirectory.appending(path: "Events.txt")
        let decoder = JSONDecoder()
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let calendarData = try decoder.decode(Events.self, from: data)
            
            return calendarData
        } catch {
            print(error.localizedDescription)
        }
        
        return Events(saveTime: Date.now, dayEvents: [])
    }
    
}

// MARK: Remote Encoding/Decoding
extension EventsModel {
    func encodeAndSendToDatabase() {
        let jsonEncoder = JSONEncoder()
        do {
            let eventsJson = try jsonEncoder.encode(calendar)
            guard let bookJsonString = String(data: eventsJson, encoding: .utf8) else {
                print("JSON Failed to convert to string")
                return
            }
            
            // 2. Specify where in your database tree you want to send data
            // For example, if you want to store it under a "my_items" node
            let itemsRef = ref.child("cconnect_events")
            
            // 3. To add a new, unique item every time, use childByAutoId()
            // This generates a unique key (like a timestamp-based ID)
            let newItemRef = itemsRef.childByAutoId()
            
            // 4. Set the value! You can pass dictionaries, arrays, strings, numbers, booleans, etc.
            newItemRef.setValue(bookJsonString) { (error, ref) in
                if let error = error {
                    print("Data could not be saved: \(error.localizedDescription)")
                } else {
                    print("Data saved successfully!")
                }
            }
        }
        catch {
            print("Error parsing JSON for response")
        }
    }
    
    // TODO: DEBUG #000000 TO WHITE WHEN RETRIEVING FROM DATABASE
    // TODO: REPLACE SPECIFIC FIELD INSTEAD OF POPULATING NEW FIELD
    // TODO: CREATE FUNCTION FOR CREATING NEW JSON FIELD
    func requestAndDecodeFromDatabase(limit: UInt = 1, completion: @escaping (Events?) -> Void) { // Default to 100 most recent posts
        
        let decoder = JSONDecoder()
        let postsRef = ref.child("cconnect_events")// Still assuming your posts are under a "posts" node
        var events = EventsModel.EmptyEvents()
        
        // 1. Create a query to get only the very last post
        //    (Because push() keys are chronological, 'last' means 'most recent')
        let lastPostQuery = postsRef.queryLimited(toLast: 1)
        
        // 2. Use observeSingleEvent(of: .value) to get the data exactly once.
        lastPostQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            // This 'snapshot' will contain the single last post if one exists,
            // or it will be empty if there are no posts.
            
            if snapshot.exists() {
                // Since we queried for queryLimited(toLast: 1), this snapshot
                // will contain one child. We need to iterate its children.
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot {
                        do {
                            guard
                                let postD = childSnapshot.value as? String,
                                let postObj = postD.data(using: .utf8)
                            else {
                                print("Error converting Snapshot into Events")
                                return
                            }

                            events = try decoder.decode(Events.self, from: postObj)
                            completion(events)
                        } catch {
                            print("no")
                        }
                    }
                }
            } else {
                print("No posts found in the database.")
            }
            
        }) { (error) in
            print("Error fetching last post: \(error.localizedDescription)")
        }
    }

    // TODO: INTEGRATE WITH CLOUD STORAGE FOR PULLING INFORMATION
    // WILL BE TRANSITIONED TO ASYNC FOR NETWORK CALLS
//    func populateAttendees() {
//        
//    }
        
}
extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
