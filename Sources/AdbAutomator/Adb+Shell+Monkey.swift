//
//  File.swift
//  
//
//  Created by Cirno MainasuK on 2020-5-12.
//

import Foundation

extension Adb.Shell.Monky {
    
    public static func open(package: String) -> Result<String, Adb.Error> {
        return Adb.adb(arguments: ["shell", "monkey", "-p", package, "-c", "android.intent.category.LAUNCHER", "1"])
    }
    
}
