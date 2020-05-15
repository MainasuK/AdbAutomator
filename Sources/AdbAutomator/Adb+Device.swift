//
//  File.swift
//  
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import Foundation

extension Adb {
    
    /// Adb Device
    ///
    ///     adb -s <device.serialno> …
    ///
    public struct Device {
        let serialno: String
        var status: Status
        var product: String?
        var model: String?
        var device: String?
        var transportID: String?
        
        public init(
            serialno: String,
            status: Status,
            product: String? = nil,
            model: String? = nil,
            device: String? = nil,
            transportID: String? = nil
        ) {
            self.serialno = serialno
            self.status = status
            self.product = product
            self.model = model
            self.device = device
            self.transportID = transportID
        }
        
        /// Adb device status
        public enum Status: String {
            case offline
            case bootloader
            case device
        }
    }
    
}

extension Adb {
    
    public static func devices() -> Result<[Device], Adb.Error> {
        let output = adb(arguments: ["devices", "-l"])
        let devices = output.flatMap { output -> Result<[Device], Adb.Error> in
            guard output.starts(with: "List of devices attached") else {
                return .failure(Adb.Error.devices(message: "cannot read devices output"))
            }
            
            // buffer
            var devices: [Device] = []
            
            let scanner = Scanner(string: output)
            scanner.charactersToBeSkipped = .whitespacesAndNewlines
            _ = scanner.scanString("List of devices attached")
            while let into = scanner.scanUpToCharacters(from: .newlines) {
                // split infos
                var infos = (into as String).split(separator: " ", maxSplits: Int.max, omittingEmptySubsequences: true).map { String($0) }
                guard infos.count >= 2 else { continue }
                
                // init device
                let serialno = infos.removeFirst()
                guard let status = Device.Status(rawValue: infos.removeFirst()) else { continue }
                var device = Device(serialno: serialno, status: status)
                
                let infoComponents = infos.map { $0.components(separatedBy: ":")}
                for component in infoComponents where component.count == 2 {
                    switch component[0] {
                    case "product":     device.product = component[1]
                    case "model":       device.model = component[1]
                    case "device":      device.device = component[1]
                    case "transport_id":   device.transportID = component[1]
                    default: continue
                    }
                }
                
                devices.append(device)
            }
            
            return .success(devices)
        }
        
        return devices
    }
}
