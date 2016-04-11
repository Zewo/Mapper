//
//  InitializableTests.swift
//  StructuredDataMapper
//
//  Created by Oleg Dreyman on 02.04.16.
//
//

import XCTest
import StructuredData
@testable import StructuredDataMapper

class InitializableTests: XCTestCase {
    
    static var allTests: [(String, InitializableTests -> () throws -> Void)] {
        return [
            ("testInt", testInt),
            ("testString", testString),
            ("testDouble", testDouble)
        ]
    }

    func testInt() {
        let structuredData: StructuredData = 5.0
        let int = try! Int(structuredData: structuredData)
        XCTAssertEqual(int, 5)
    }
    
    func testString() {
        let structuredData: StructuredData = "Some"
        let string = try! String(structuredData: structuredData)
        XCTAssertEqual(string, "Some")
    }
    
    func testDouble() {
        let structuredData: StructuredData = 17.0
        let double = try! Double(structuredData: structuredData)
        XCTAssertEqual(double, 17.0)
    }
    
}
