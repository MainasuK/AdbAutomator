//
//  File.swift
//  
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import os
import Foundation

public enum Adb {
    
    static let adbLaunchPath = "/usr/local/bin/adb"
    
    /// Execuate adb with arguments
    ///
    ///     adb(["devices", "-l"])
    ///
    /// - Parameters:
    ///   - arguments: the aruguments for adb
    ///   - environment: the enviroment for adb. Inherit for parent if `nil`
    /// - Returns: the adb output
    public static func adb(
        arguments: [String] = [],
        environment: [String: String]? = nil
    ) -> Result<String, Adb.Error> {
        let result = shell(launchPath: adbLaunchPath, arguments: arguments, environment: environment)
        
        let _arguments = arguments.joined(separator: " ")
        do {
            let output = try result.get()
            os_log(.debug, log: .adb, "%{public}s[%{public}ld], %{public}s:\n$ adb %s\n%s", ((#file as NSString).lastPathComponent), #line, #function, _arguments, output)
        } catch {
            os_log(.debug, log: .adb, "%{public}s[%{public}ld], %{public}s:\n$ adb %s\n%{public}s", ((#file as NSString).lastPathComponent), #line, #function, _arguments, error.localizedDescription)
        }
        
        return result
    }
    
    /// Execuate adb with arguments
    ///
    ///     adb(["shell", "screencap"])
    ///
    /// - Parameters:
    ///   - arguments: the aruguments for adb
    ///   - environment: the enviroment for adb. Inherit for parent if `nil`
    /// - Returns: the adb raw data output
    public static func adbData(
        arguments: [String] = [],
        environment: [String: String]? = nil
    ) -> Result<Data, Adb.Error> {
        let result = shellData(launchPath: adbLaunchPath, arguments: arguments, environment: environment)
        
        let _arguments = arguments.joined(separator: " ")
        do {
            let output = try result.get()
            os_log(.debug, log: .adb, "%{public}s[%{public}ld], %{public}s:\n$ adb %s\n%s", ((#file as NSString).lastPathComponent), #line, #function, _arguments, output.description)
        } catch {
            os_log(.debug, log: .adb, "%{public}s[%{public}ld], %{public}s:\n$ adb %s\n%{public}s", ((#file as NSString).lastPathComponent), #line, #function, _arguments, error.localizedDescription)
        }
        
        return result
    }

}

