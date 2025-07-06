//
//  DatesAndMonths.swift
//  CConnect
//
//  Created by Reo Ogundare on 6/26/25.
//

import SwiftUI
import SwiftData
import MijickCalendarView

// MARK: Calendar modifications
/// Calendar Day View
enum DV {}

/// Calendar Month Label
enum ML {}

extension ML { struct Center: MonthLabel {
    let month: Date

    func createContent() -> AnyView {
        Text(getString(format: "MMMM yyyy").uppercased())
            .font(.body)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .center)
            .erased()
    }
}}

// MARK: Date
extension Date {
    func add(_ number: Int, _ component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: number, to: self) ?? Date()
    }
    func isSame(_ date: Date) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
}

// MARK: Colored Circle
extension DV { struct ColoredCircle: DayView {
    var date: Date
    var color: Color?
    var isCurrentMonth: Bool
    var selectedDate: Binding<Date?>?
    var selectedRange: Binding<MDateRange?>?
}}

extension DV.ColoredCircle {
    func createDayLabel() -> AnyView {
        ZStack {
            createDayLabelBackground()
            createDayLabelText()
        }
        .erased()
    }
    func createSelectionView() -> AnyView {
        Circle()
            .fill(.clear)
            .strokeBorder(.primary, lineWidth: 1)
            .transition(.asymmetric(insertion: .scale(scale: 0.5).combined(with: .opacity), removal: .opacity))
            .active(if: isSelected() && !isPast())
            .erased()
    }
}
private extension DV.ColoredCircle {
    func createDayLabelBackground() -> some View {
        Circle()
            .fill(isSelected() ? .primary : color ?? .clear)
            .padding(4)
    }
    func createDayLabelText() -> some View  {
        Text(getStringFromDay(format: "d"))
            .font(.body)
            .foregroundColor(getTextColor())
            .strikethrough(isPast())
    }
}
private extension DV.ColoredCircle {
    func getTextColor() -> Color {
        guard !isPast() else { return .secondary }
        
        switch isSelected() {
        case true: return .primary
            case false: return color == nil ? .primary : .white
        }
    }
    func getBackgroundColor() -> Color {
        guard !isPast() else { return .clear }

        switch isSelected() {
            case true: return .primary
            case false: return color ?? .clear
        }
    }
}

// MARK: - On Selection Logic
extension DV.ColoredCircle {
    func onSelection() {
        if !isPast() { selectedDate?.wrappedValue = date }
    }
}

// MARK: - Active Flag
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View { if condition { self } }
}
