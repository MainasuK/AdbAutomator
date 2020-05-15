//
//  Shell.swift
//  
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import Foundation

/// Execuate a sub-process at lanchPath
///
///     shell("/usr/bin/uname", ["-a"])
///
/// - Parameters:
///   - launchPath: the process lauching path for `Process`
///   - arguments: the arguments for `Process`
///   - environment: the enviroment for `Process`. Inherit for parent if `nil`
/// - Returns: the process stdout & stderr output
func shell(
    launchPath: String,
    arguments: [String] = [],
    environment: [String: String]? = nil
) -> Result<String, Adb.Error> {
    // init task
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    if let environment = environment {
        task.environment = environment
    }
    
    // setup stdout & stderr
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    // launch task
    task.launch()
    
    // read output
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    
    task.waitUntilExit()
    
    // return result
    guard task.terminationStatus == 0 else {
        return .failure(Adb.Error.exit(terminationStatus: task.terminationStatus, output: output))
    }
    return .success(output)
}

/// Execuate a sub-process at lanchPath
///
///     shell("/usr/bin/uname", ["-a"])
///
/// - Parameters:
///   - launchPath: the process lauching path for `Process`
///   - arguments: the arguments for `Process`
///   - environment: the enviroment for `Process`. Inherit for parent if `nil`
/// - Returns: the process stdout & stderr raw data output
func shellData(
    launchPath: String,
    arguments: [String] = [],
    environment: [String: String]? = nil
) -> Result<Data, Adb.Error> {
    // init task
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    if let environment = environment {
        task.environment = environment
    }
    
    // setup stdout & stderr
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    // launch task
    task.launch()
    
    // read output
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = data
    
    task.waitUntilExit()
    
    // return result
    guard task.terminationStatus == 0 else {
        return .failure(Adb.Error.exit(terminationStatus: task.terminationStatus, output: data.description))
    }
    return .success(output)
}
