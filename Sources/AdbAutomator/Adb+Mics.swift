//
//  File.swift
//  
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import Foundation

extension Adb {
    
    public static func killServer() {
        _ = adb(arguments: ["kill-server"])
    }
    
}
