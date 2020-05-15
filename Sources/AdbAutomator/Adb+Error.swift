//
//  Adb+Error.swift
//
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import Foundation

extension Adb {
    
    public enum Error: Swift.Error, LocalizedError {
        
        case exit(terminationStatus: Int32, output: String)
        case devices(message: String)
        case screencap(message: String)
        
        public var errorDescription: String? {
            switch self {
            case let .exit(terminationStatus, output):
                return "Error Code: \(terminationStatus).\nOutput: \(output)"
            case let .devices(message):
                return message
            case let .screencap(message):
                return message
            }
        }
        
    }
    
}
