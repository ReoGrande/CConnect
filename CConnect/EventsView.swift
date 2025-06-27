//
//  EventsView.swift
//  CConnect
//
//  Created by Reo Ogundare on 6/26/25.
//

import SwiftUI

extension ContentView {
    struct EventsView: View {
        @Binding var selectedDate: Date?
        let events: [Date: [Event]]
        
        var body: some View {
            VStack() {
                createTitle()
                createContent()
            }
        }
    }
}

private extension ContentView.EventsView {
    func createTitle() -> some View {
        Text(title)
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    @ViewBuilder func createContent() -> some View {
        switch events[selectedDate] {
            case .some(let events): createEventsList(events)
            case .none: EmptyView()
        }
    }
}

private extension ContentView.EventsView {
    func createEventsList(_ events: [Event]) -> some View {
        VStack(spacing: 16) {
            ForEach(events, id: \.self, content: createElement)
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
private extension ContentView.EventsView {
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
private extension ContentView.EventsView {
    var title: String {
        guard let selectedDate else { return "" }
        if Date.now.isSame(selectedDate) { return "TODAY" }
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

fileprivate typealias Event = ContentView.Event

