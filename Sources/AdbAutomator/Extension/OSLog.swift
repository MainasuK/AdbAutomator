//
//  File.swift
//  
//
//  Created by MainasuK Cirno on 2020/3/12.
//

import os
import Foundation
import CommonOSLog

extension OSLog {
    static let adb = OSLog(subsystem: OSLog.subsystem + ".adb", category: "adb")
}
