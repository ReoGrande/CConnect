//
//  EventDetailView.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/6/25.
//

import SwiftUI

extension CalendarView.EventsView {
    func createEventDetailView(event: Event) -> some View {
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
            createAttendeeView(event: event)
                .frame(height: 250)
            Spacer()
            HStack {
                if Date.now.add(-1, .day) < event.date {
                    if isAttendee(event: event) {
                        Button("Leave") {
                            leaveEvent(event: event)
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button("Join") {
                            joinEvent(event: event)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            
        }
        .padding(25)
        .navigationTitle(event.name)
    }

    func joinEvent(event: Event) {
        if
            !event.attendees.contains(where: { attendee in
            attendee.id == UserModel.shared.user.id
        }) {
            var newAttendees = event.attendees
            newAttendees.append(UserModel.shared.user)
            
            let modifiedEvent = Event(
                id: event.id,
                name: event.name,
                range: event.range,
                color: event.color,
                date: event.date,
                attendees: newAttendees)
            
            DispatchQueue.main.async {
                eventsModel.calendar.modifyEvent(day: event.date, eventToModify: event, modifiedEvent: modifiedEvent)
                
                UserModel.shared.addEventToAttendance(modifiedEvent)
            }
        }
    }

    func leaveEvent(event: Event) {
        if
            Date.now.add(-1, .day) < event.date &&
                event.attendees.contains(
                    where: {
                        attendee in
                        attendee.id == UserModel.shared.user.id
                    }
                ) {
            let newAttendees = event.attendees.filter { attendee in
                attendee.id != UserModel.shared.user.id
            }

            let modifiedEvent = Event(
                id: event.id,
                name: event.name,
                range: event.range,
                color: event.color,
                date: event.date,
                attendees: newAttendees)
            
            DispatchQueue.main.async {
                eventsModel.calendar.modifyEvent(day: event.date, eventToModify: event, modifiedEvent: modifiedEvent)
                
                UserModel.shared.removeEventFromAttendance(modifiedEvent)
            }
        }
    }

    func isAttendee(event: Event) -> Bool {
        event.attendees.contains { attendee in
            attendee.id == UserModel.shared.user.id
        }
    }

    func createAttendeeView(event: Event) -> some View {
        VStack {
            Text("Attendees: \(event.attendees.count)")
                .font(.largeTitle)
                .bold()
            Divider()
            ScrollView {
                VStack {
                    ForEach(event.attendees, id: \.self) { attendee in
                        Text(attendee.getFullName())
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 15)
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(.ultraThinMaterial)
        .cornerRadius(5)

    }
}
