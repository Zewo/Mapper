//
//  InitializableTests.swift
//  InterchangeDataMapper
//
//  Created by Oleg Dreyman on 02.04.16.
//
//

import XCTest
import InterchangeData
@testable import InterchangeDataMapper

class InitializableTests: XCTestCase {

    func testInt() {
        let interchangeData: InterchangeData = 5.0
        let int = try! Int(interchangeData: interchangeData)
        XCTAssertEqual(int, 5)
    }
    
    func testString() {
        let interchangeData: InterchangeData = "Some"
        let string = try! String(interchangeData: interchangeData)
        XCTAssertEqual(string, "Some")
    }
    
    func testDouble() {
        let interchangeData: InterchangeData = 17.0
        let double = try! Double(interchangeData: interchangeData)
        XCTAssertEqual(double, 17.0)
    }
    
}
