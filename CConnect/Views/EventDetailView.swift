//
//  EventDetailView.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/6/25.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event
    
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
            Text("Attendees")
                .font(.largeTitle)
                .bold()
            Divider()
            ScrollView {
                VStack {
                    ForEach(mockAttendees, id: \.self) { attendee in
                        Text(attendee)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 15)
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(.ultraThinMaterial)
        .cornerRadius(5)

    }
}

private let mockAttendees: [String] = [
    "Amanda L",
    "Alex K",
    "Jake M",
    "Erin N",
    "Ronald X",
    "Elizabeth W",
    "Crooks L",
    "Gerald C",
    "Frank K",
    "Daniel F"
]
