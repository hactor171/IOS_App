//
//  NetworkStateClass.swift
//  ProjectAppIOS
//
//  Created by Роман on 08.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit
import Network

class NetworkStateClass {

    static let shared = NetworkStateClass()
     
     var monitor: NWPathMonitor?
     
     var isMonitoring = false
    
     var netStatusChangeHandler: (() -> Void)?
     
     
     var isConnected: Bool {
         guard let monitor = monitor else { return false }
         return monitor.currentPath.status == .satisfied
     }
     
     
     var interfaceType: NWInterface.InterfaceType? {
         guard let monitor = monitor else { return nil }
         
         return monitor.currentPath.availableInterfaces.filter {
             monitor.currentPath.usesInterfaceType($0.type) }.first?.type
     }
     
     
     var availableInterfacesTypes: [NWInterface.InterfaceType]? {
         guard let monitor = monitor else { return nil }
         return monitor.currentPath.availableInterfaces.map { $0.type }
     }
     
     
     var isExpensive: Bool {
         return monitor?.currentPath.isExpensive ?? false
     }
     
     
     /*private init() {
         startMonitoring()
     }
     
     
     deinit {
         stopMonitoring()
     }*/
     

     
     func startMonitoring() {
         guard !isMonitoring else { return }
         
         monitor = NWPathMonitor()
         let queue = DispatchQueue(label: "NetStatus_Monitor")
         monitor?.start(queue: queue)
         
         monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
         }
         
         isMonitoring = true
     }
     
     
     func stopMonitoring() {
         guard isMonitoring, let monitor = monitor else { return }
         monitor.cancel()
         self.monitor = nil
         isMonitoring = false
     }
    
}
