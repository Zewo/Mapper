// RawRepresentableValueTests.swift
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
@testable import Mapper

class RawRepresentableValueTests: XCTestCase {
    static var allTests: [(String, RawRepresentableValueTests -> () throws -> Void)] {
        return [
            ("testRawRepresentable", testRawRepresentable),
            ("testRawRepresentableNumber", testRawRepresentableNumber),
            ("testRawRepresentableInt", testRawRepresentableInt),
            ("testMissingRawRepresentableNumber", testMissingRawRepresentableNumber),
            ("testOptionalRawRepresentable", testOptionalRawRepresentable),
            ("testExistingOptionalRawRepresentable", testExistingOptionalRawRepresentable),
            ("testRawRepresentableTypeMismatch", testRawRepresentableTypeMismatch),
            ("testRawRepresentableArray", testRawRepresentableArray),
            ("testRawRepresentablePartialArray", testRawRepresentablePartialArray),
            ("testRawRepresentableOptionalArray", testRawRepresentableOptionalArray),
            ("testRawRepresentableExistingOptionalArray", testRawRepresentableExistingOptionalArray)
        ]
    }

    func testRawRepresentable() {
        enum Suits: String {
            case Hearts = "hearts"
            case Barney = "barney"
        }
        struct Test: Mappable {
            let suit: Suits
            init(map: Mapper) throws {
                try self.suit = map.from("suit")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["suit": "barney"]))
        XCTAssertEqual(test.suit, Suits.Barney)
    }
    
    func testRawRepresentableNumber() {
        enum Value: Double {
            case first = 1.0
        }
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["value": 1.0]))
        XCTAssertEqual(test.value, Value.first)
    }
    
    func testRawRepresentableInt() {
        enum Value: Int {
            case first = 1
        }
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["value": 1]))
        XCTAssertEqual(test.value, Value.first)
    }
    
    func testMissingRawRepresentableNumber() {
        enum Value: Double {
            case First = 1.0
        }
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }
        let test = try? Test(map: Mapper(structuredData: .nullValue))
        XCTAssertNil(test)
    }
    
    func testOptionalRawRepresentable() {
        enum Value: Double {
            case First = 1.0
        }
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }
        let test = try! Test(map: Mapper(structuredData: .nullValue))
        XCTAssertNil(test.value)
    }
    
    func testExistingOptionalRawRepresentable() {
        enum Value: Double {
            case First = 1.0
        }
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["value": 1.0]))
        XCTAssertEqual(test.value, Value.First)
    }
    
    func testRawRepresentableTypeMismatch() {
        enum Value: Double {
            case First = 1.0
        }
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["value": "cike"]))
        XCTAssertNil(test.value)
    }
    
    func testRawRepresentableArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]
            init(map: Mapper) throws {
                try self.barneys = map.arrayFrom("barneys")
            }
        }
        let barneysContent: StructuredData = ["barneys": ["legendary", "stinson", "awesome"]]
        let test = try! Test(map: Mapper(structuredData: barneysContent))
        XCTAssertEqual(test.barneys, [Barney.legendary, Barney.stinson, Barney.awesome])
    }
    
    func testRawRepresentablePartialArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]
            init(map: Mapper) throws {
                try self.barneys = map.arrayFrom("barneys")
            }
        }
        let barneysContent: StructuredData = ["barneys": ["legendary", "stinson", "captain"]]
        let test = try! Test(map: Mapper(structuredData: barneysContent))
        XCTAssertEqual(test.barneys, [Barney.legendary, Barney.stinson])
    }
    
    func testRawRepresentableOptionalArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]?
            init(map: Mapper) throws {
                self.barneys = map.optionalArrayFrom("barneys")
            }
        }
        let test = try! Test(map: Mapper(structuredData: .nullValue))
        XCTAssertNil(test.barneys)
    }
    
    func testRawRepresentableExistingOptionalArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]?
            init(map: Mapper) throws {
                self.barneys = map.optionalArrayFrom("barneys")
            }
        }
        let barneysContent: StructuredData = ["barneys": ["legendary", "stinson", "awesome"]]
        let test = try! Test(map: Mapper(structuredData: barneysContent))
        XCTAssertEqual(test.barneys!, [Barney.legendary, Barney.stinson, Barney.awesome])
    }
}
