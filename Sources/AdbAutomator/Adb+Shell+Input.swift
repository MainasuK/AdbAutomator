//
//  Adb+Shell+Input.swift
//  
//
//  Created by Cirno MainasuK on 2020-5-3.
//

import os
import Foundation

extension Adb.Shell.Input {
    
    public static func tap(point: CGPoint) -> Result<String, Adb.Error> {
        Adb.adb(arguments: ["shell", "input", "tap", "\(point.x)", "\(point.y)"])
    }
    
    public static func text(text: String) -> Result<String, Adb.Error> {
        return Adb.adb(arguments: ["shell", "input", "text", "\"\(text)\""])
    }
    
}
