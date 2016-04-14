// InitializableTests.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Oleg Dreyman
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
import Mapper

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
