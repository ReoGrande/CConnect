//
//  Helpers+Constants.swift
//  CConnect
//
//  Created by Reo Ogundare on 3/2/25.
//

import SwiftUI

final class Helpers {
    static func currentDateInDateComponents() -> DateComponents {
        return Calendar.current.dateComponents([.day,.month,.year], from: Date())
    }
    static var colors = ["#0077A2":"Celadon Blue",
                         "#CD2504":"Extreme Red ",
                         "#130A06":"Asphalt Black",
                         "#1DB954":"Spotify Green",
                         "#9241C5":"Charming Purple",
                         "#F3BD12":"24K Gold",
                         "#58111A":"Chocolate Cosmos",
                         "#000080":"Digital Navy",
                         "#FD28EC":"Vivid Fuchsia",
                         "#F37507":"Extreme Orange",
                         "#FFFFFF":"White",
                         "#000000":"Black"]
    static let mockAttendees: [String] = [
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
}

extension Helpers {
    static let mockAttendeesUsers: [User] = [
        User(first: "Amanda", last: "Lebowski", history: Helpers.uuids()),
        User(first: "John", last: "Doe", history: Helpers.uuids()),
        User(first: "Jane", last: "Smith", history: Helpers.uuids()),
        User(first: "Peter", last: "Jones", history: Helpers.uuids()),
        User(first: "Sarah", last: "Connor", history: Helpers.uuids()),
        User(first: "Michael", last: "Jordan", history: Helpers.uuids())
    ]
    static func uuids() -> [UUID] {
//        [UUID(uuidString:"C76B8E12-C47B-46F6-828F-2A5B0DF6758F") ?? UUID(),
//         UUID(uuidString:"77036EAE-AF96-466D-BB54-BFE6EF0CC14B") ?? UUID(),
//         UUID(uuidString:"13D5E952-751B-4D62-B9F9-21C985499D32") ?? UUID(),
//        ]
        []
    }
}
