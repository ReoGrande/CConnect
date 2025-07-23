//
//  NetworkMonitor.swift
//  CConnect
//
//  Created by Reo Ogundare on 7/23/25.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    @Published var isConnected = false
    @Published var isExpensive = false // Add for expensive connections
    @Published var isConstrained = false // Add for constrained connections
    @Published var interfaceType: NWInterface.InterfaceType? // Add for interface type

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isExpensive = path.isExpensive
                self?.isConstrained = path.isConstrained
                self?.interfaceType = path.availableInterfaces.first?.type
            }
        }
    }

    func startMonitoring() {
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
