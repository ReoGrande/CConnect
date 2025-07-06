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
        event.color
            .opacity(0.2)
            .overlay(
                VStack(spacing: 15) {
                    Spacer()
                    Text(event.name)
                    Text(event.range)
                    Spacer()
                }
        )
    }
}
