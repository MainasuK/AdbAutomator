//
//  File.swift
//  
//
//  Created by Cirno MainasuK on 2020-5-3.
//

import os
import XCTest
@testable import AdbAutomator

final class TouchTests: XCTestCase {
    
    func testSmoke() {
        
    }
    
    func testTap() throws {
        _ = Adb.tab(point: CGPoint(x: 10, y: 10))
    }
    
}
