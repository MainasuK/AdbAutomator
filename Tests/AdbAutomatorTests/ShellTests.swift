//
//  ShellTests.swift
//  
//
//  Created by MainasuK Cirno on 2020/3/7.
//

import os
import XCTest
@testable import AdbAutomator

final class ShellTests: XCTestCase {
    
    func testSmoke() {
        
    }
    
    func testShell() throws {
        let output = try shell(launchPath: "/usr/bin/uname").get()
        XCTAssertEqual(output, "Darwin\n")
    }

}
