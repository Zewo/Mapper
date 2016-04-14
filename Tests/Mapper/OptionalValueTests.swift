// OptionalValueTests.swift
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

final class OptionalValueTests: XCTestCase {
    static var allTests: [(String, OptionalValueTests -> () throws -> Void)] {
        return [
            ("testMappingToClass", testMappingToClass),
            ("testMappingOptionalValue", testMappingOptionalValue),
            ("testMappingOptionalExisitngValue", testMappingOptionalExisitngValue),
            ("testMappingOptionalArray", testMappingOptionalArray),
            ("testMappingOptionalExistingArray", testMappingOptionalExistingArray),
        ]
    }

    func testMappingToClass() {
        final class Test: Mappable {
            let string: String
            required init(map: Mapper) throws {
                self.string = map.optionalFrom("string") ?? ""
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["string": "Hello"]))
        XCTAssertEqual(test.string, "Hello")
    }
    
    func testMappingOptionalValue() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                self.string = map.optionalFrom("whiskey")
            }
        }
        let test = try! Test(map: Mapper(structuredData: .nullValue))
        XCTAssertNil(test.string)
    }

    func testMappingOptionalExisitngValue() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                string = map.optionalFrom("whiskey")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["whiskey": "flows"]))
        XCTAssertEqual(test.string, "flows")
    }
    
    func testMappingOptionalArray() {
        struct Test: Mappable {
            let strings: [String]?
            init(map: Mapper) throws {
                self.strings = map.optionalArrayFrom("whiskey")
            }
        }
        let test = try! Test(map: Mapper(structuredData: .nullValue))
        XCTAssertNil(test.strings)
    }
    
    func testMappingOptionalExistingArray() {
        struct Test: Mappable {
            let strings: [String]?
            init(map: Mapper) throws {
                self.strings = map.optionalArrayFrom("whiskey")
            }
        }
        let test = try! Test(map: Mapper(structuredData: ["whiskey": ["lera", "lynn"]]))
        XCTAssertEqual(test.strings!, ["lera", "lynn"])
    }
}
