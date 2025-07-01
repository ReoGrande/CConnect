//
//  DayType+Days.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/1/25.
//

public enum DayType: String {
        case Sun = "Sun"
        case Mon = "Mon"
        case Tue = "Tue"
        case Wed = "Wed"
        case Thu = "Thu"
        case Fri = "Fri"
        case Sat = "Sat"
        
    static func isWeekDay(day: String) -> Bool {
        switch DayType(rawValue: day) {
        case .Sun, .Sat:
            return false
        case .Mon, .Tue, .Wed, .Thu, .Fri :
            return true
        default:
            print("DayType: Error checking weekday")
            print(day)
            print(DayType(rawValue: day))
            return true
        }
    }
}
