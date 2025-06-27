//
//  EventBuilder.swift
//  CConnect
//
//  Created by Reo Ogundare on 6/27/25.
//

import SwiftUI

class EventBuilder {
    var eventsModel: [Date: [CalendarView.Event]]?
    init(eventsModel: [Date : [CalendarView.Event]]? = nil) {
        self.eventsModel = eventsModel
    }

    func buildMonthMockDatesBPVASummer(monthStart: Date) {
        
    }
}

fileprivate extension [Date: [CalendarView.Event]] {
    init() {
        let events1: [CalendarView.Event] = [
            .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: .red),
            .init(name: "Lift", range: "05:30pm - 06:30pm", color: .black),
            .init(name: "Vault Session #1", range: "06:30pm - 08:30pm", color: .red)
        ]
        let events2: [CalendarView.Event] = [
            .init(name: "Vault Session #1", range: "03:30pm - 05:30pm", color: .red),
            .init(name: "Lift", range: "05:30pm - 06:30pm", color: .black),
            .init(name: "Vault Session #1", range: "06:30pm - 08:30pm", color: .red)
        ]
        let events3: [CalendarView.Event] = [ .init(name: "Vault Competition", range: "10:00am - 5:00pm", color: .red) ]
        
        self = [ Date.now: events1, Date.now.add(1, .day): events2, Date.now.add(2, .day): events3 ]
    }
}

fileprivate let vaultSession = "Vault Session"
fileprivate let liftSession = "Lift"
fileprivate let CompetitionSession = "Vault Competition"



