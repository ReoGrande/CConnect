//
//  EventsView.swift
//  CConnect
//
//  Created by Reo Ogundare on 6/26/25.
//

import SwiftUI

extension CalendarView {
    struct EventsView: View {
        @Binding var selectedDate: Date?
        @Binding var events: [DayEvents]

        var body: some View {
            VStack() {
                createTitle()
                createContent()
                Spacer()
            }
        }
    }
}

private extension CalendarView.EventsView {
    func createTitle() -> some View {
        Text(title)
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    @ViewBuilder func createContent() -> some View {
        switch events.first(where: { dayEvents in
            dayEvents.date == selectedDate
        }) {
            case .some(let events): createEventsList(events)
            case .none: EmptyView()
        }
    }
}

//TODO: SEPARATE INTO A EVENTSLISTVIEW
private extension CalendarView.EventsView {
    func createEventsList(_ events: DayEvents) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(events.day, id: \.self) { event in
                    HStack(spacing: 10) {
                        createColoredIndicator(event)

                        NavigationLink {
                            EventDetailView(event: event)
                        } label: {
                            VStack(spacing: 4) {
                                createEventTitle(event)
                                createEventSubtitle(event)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }

    func createElement(_ event: Event) -> some View {
        HStack(spacing: 10) {
            createColoredIndicator(event)
            
            VStack(spacing: 4) {
                createEventTitle(event)
                createEventSubtitle(event)
            }
        }
    }
}
// MARK: Event UI
private extension CalendarView.EventsView {
    func createColoredIndicator(_ event: Event) -> some View  {
        RoundedRectangle(cornerRadius: 3)
            .fill(event.color)
            .frame(width: 6, height: 20)
    }
    func createEventTitle(_ event: Event) -> some View {
        Text(event.name)
            .font(.body)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func createEventSubtitle(_ event: Event) -> some View {
        Text(event.range)
            .font(.body)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
private extension CalendarView.EventsView {
    var title: String {
        guard let selectedDate else { return "" }
        if CalendarView.dateNow().isSame(selectedDate) { return "TODAY" }
        else { return day.uppercased() }
    }
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: selectedDate ?? Date())
    }
}

// MARK: Helpers
fileprivate extension [Date: [Event]] {
    subscript(_ key: Date?) -> [Event]? {
        guard let key else { return nil }
        return self.first(where: { $0.key.isSame(key) })?.value
    }
}
