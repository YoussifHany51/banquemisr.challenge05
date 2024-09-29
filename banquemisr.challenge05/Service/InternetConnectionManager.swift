//
//  InternetConnectionManager.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 29/09/2024.
//

import Foundation
import Network

class InternetConnectionManager{
    static let shared = InternetConnectionManager()
       private let monitor = NWPathMonitor()
       private var isConnected = true

       func startMonitoring() {
           monitor.pathUpdateHandler = { path in
               self.isConnected = path.status == .satisfied
           }
           let queue = DispatchQueue(label: "NetworkMonitor")
           monitor.start(queue: queue)
       }

       func stopMonitoring() {
           monitor.cancel()
       }

       func isNetworkAvailable() -> Bool {
           return isConnected
       }
}
