//
//  EventDetailView.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/6/25.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event

    @State var attendeesUsers: [User]?
    // TODO: FIX POPULATING ATTENDEES FROM UUID
    init(event: Event, attendeesUsers: [User]? = nil) {
        self.event = event
        populateAttendees()
    }

    var body: some View {
        VStack(spacing: 25) {
            event.color
                .opacity(0.2)
                .overlay(
                    // TODO: INTRODUCE DATE INTO EVENT MODEL
                    VStack {
                        Text("Date: TBD")
                        Text("Time: \(event.range)")
                    }
                )
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .cornerRadius(5)
            Divider()
            createAttendeeView()
                .frame(height: 250)
            Spacer()
            Button("Join") { }
                .buttonStyle(.borderedProminent)
            
        }
        .padding(25)
        .navigationTitle(event.name)
    }
    
    // TODO: INTRODUCE ATTENDEES INTO EVENT MODEL
    func createAttendeeView() -> some View {
        VStack {
            Text("Attendees: \(event.attendees.count)")
                .font(.largeTitle)
                .bold()
            Divider()
            ScrollView {
                VStack {
                    if let attendeeUsers = attendeesUsers {
                        ForEach(attendeeUsers, id: \.self) { attendee in
                            Text(attendee.getFullName())
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
            .padding(.top, 15)
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(.ultraThinMaterial)
        .cornerRadius(5)

    }

    func populateAttendees() {
        self.attendeesUsers = event.getAttendees()
    }
    
}
