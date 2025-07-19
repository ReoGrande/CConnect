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
}
