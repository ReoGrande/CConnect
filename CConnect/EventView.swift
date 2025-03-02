//
//  EventView.swift
//  CConnect
//
//  Created by Reo Ogundare on 3/2/25.
//

import SwiftUI

struct EventView: View {
    @Binding var Event: EventModel
    var body: some View {
        Text(Event.eventName)
        Text(Event.date.description)
        ForEach(Event.members, id: \.self) { member in
                Text(member)
        }
    }
}

#Preview {
    struct EventPreview: View {
        @State var mockEvent = EventModel.MockCreateEventModel(numberOfPeople: 5, date: Helpers.currentDateInDateComponents())
        var body: some View {
            EventView(Event: $mockEvent)
        }
    }
    return EventPreview()
}
