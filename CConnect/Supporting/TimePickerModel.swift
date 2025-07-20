//
//  TimePickerModel.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/20/25.
//

import SwiftUI

class TimePickerModel: ObservableObject {
    @Published var startTime: TimeModel
    @Published var endTime: TimeModel
    var totalRange: String {
        rangeToString()
    }

    init() {
        self.startTime = TimeModel()
        self.endTime = TimeModel()
    }

    init(startTime: TimeModel, endTime: TimeModel) {
        self.startTime = startTime
        self.endTime = endTime
    }

    private func convertMinute(_ minute: Int) -> String {
        if minute < 10 {
            return "0\(minute)"
        }
        return "\(minute)"
    }

    private func rangeToString() -> String {
        let startString = "\(startTime.hour):\(convertMinute(startTime.minute)) \(startTime.apSelected)"
        let endString = "\(endTime.hour):\(convertMinute(endTime.minute)) \(endTime.apSelected)"

        return "\(startString) - \(endString)"
    }
}

class TimeModel {
    var hour: Int
    var minute: Int
    var apSelected: String


    init() {
        hour = 1
        minute = 0
        apSelected = AMPM[0]
    }
}

// TODO: move this into constants

let AMPM: [String] = ["AM", "PM"]
