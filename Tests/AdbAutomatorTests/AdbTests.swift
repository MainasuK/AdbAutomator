//
//  AdbTests.swift
//
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import os
import XCTest
@testable import AdbAutomator

final class AdbTests: XCTestCase {
    
    func testSmoke() {
        
    }
    
    func testAdb() {
         Adb.adb(arguments: ["devices -l"])
//        Adb.adb(arguments: ["devices", "-l"])
    }
    
    func testAdbDevices() throws {
        let devices = try Adb.devices().get()
        XCTAssert(!devices.isEmpty)
    }
    
    func testAdbScreencap() throws {
        let url = try Adb.screencap(destinationPath: FileManager.default.temporaryDirectory).get()
        let image = NSImage(contentsOf: url)
        XCTAssertNotNil(image)
    }
    
    func testAdbScreencapUserFileSpace() throws {
        let path = try FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = try Adb.screencap(destinationPath: path).get()
        let image = NSImage(contentsOf: url)
        XCTAssertNotNil(image)
    }
    
    // https://github.com/aosp-mirror/platform_system_core/blob/46f281edf5e78a51c5c1765460cddcf805e88d48/adb/daemon/framebuffer_service.cpp
    // https://android.googlesource.com/platform/tools/base/
    func testAdbScreencapStdout() throws {
        let screencapResult = Adb.adbData(arguments: ["shell", "screencap"])
        let imageData = try screencapResult.get()
        let image = Adb.parseRawImage(from: imageData)
        
//        try imageData.write(to: URL(string: "file:///Users/mainasuk/Downloads/hi2")!)
//        XCTAssertNotNil(image)
    }
    
}
