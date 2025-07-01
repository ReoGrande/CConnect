//
//  DateFormatter.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/1/25.
//

import SwiftUI
import MijickCalendarView

struct MDateFormatter {}

// MARK: - Date / Weekday -> String Operations
extension MDateFormatter {
    static func getString(from date: Date, format: String) -> String {
        getFormatter(format)
            .string(from: date)
            .capitalized
    }
    static func getString(for weekday: MWeekday, format: WeekdaySymbolFormat) -> String {
        switch format {
            case .veryShort: return getFormatter().veryShortWeekdaySymbols[weekday.rawValue - 1].capitalized
            case .short: return getFormatter().shortWeekdaySymbols[weekday.rawValue - 1].capitalized
            case .full: return getFormatter().standaloneWeekdaySymbols[weekday.rawValue - 1].capitalized
        }
    }
}
private extension MDateFormatter {
    static func getFormatter(_ format: String = "") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}
