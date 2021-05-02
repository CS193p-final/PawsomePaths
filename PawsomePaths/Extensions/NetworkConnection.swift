//
//  NetworkConnection.swift
//  Hex
//
//  Created by Giang Nguyenn on 3/27/21.
//

import Foundation
import Network

class NetworkConnection: ObservableObject {
    static let shared = NetworkConnection()
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool {status == .satisfied}
    var isReachableCellular: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableCellular = path.isExpensive
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
