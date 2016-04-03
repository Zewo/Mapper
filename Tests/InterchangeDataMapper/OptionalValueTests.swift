//
//  OptionalValueTests.swift
//  Topo
//
//  Created by Oleg Dreyman on 28.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import StructuredDataMapper

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
