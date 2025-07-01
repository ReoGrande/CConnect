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

struct EventModel: Hashable {
    private(set) var date: DateComponents
    private(set) var eventName: String
    private(set) var members: [String] // Later to become class/struct for member with roles for coach/athlete
    private let events: [Date: [Event]] = .init()

    
    static func MockCreateEventModel(numberOfPeople: Int, date: DateComponents) -> EventModel {
        var mockEvent = EventModel(date: Calendar.current.dateComponents([.day,.month,.year], from: Date()), eventName: "MockEvent", members: [])
        
        for i in 1...10 {
            mockEvent.addAthlete(athleteToAdd: "Athlete\(i)")
        }

        return mockEvent
    }

    mutating func addAthlete(athleteToAdd: String) {
        members.append(athleteToAdd)
    }

}
