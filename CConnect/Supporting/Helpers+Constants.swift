//
//  Helpers+Constants.swift
//  CConnect
//
//  Created by Reo Ogundare on 3/2/25.
//

import SwiftUI

final class Helpers {
    static func currentDateInDateComponents() -> DateComponents {
        return Calendar.current.dateComponents([.day,.month,.year], from: Date())
    }

// TODO: MODIFY FOR NEW EVENTSMODEL
//    static func MockBuildEventsList() -> Set<EventModel> {
//        var mockEvents = Set<EventModel>()
//        
//        for i in 1...6 {
//            mockEvents.insert(EventModel.MockCreateEventModel(numberOfPeople: i, date: Helpers.currentDateInDateComponents()))
//        }
//        
//        return mockEvents
//    }
}
