//
//  NormalValueTests.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import StructuredDataMapper

class NormalValueTests: XCTestCase {

    static var allTests: [(String, NormalValueTests -> () throws -> Void)] {
        return [
            ("testMappingString", testMappingString),
            ("testMappingMissingKey", testMappingMissingKey),
            ("testFallbackMissingKey", testFallbackMissingKey),
            ("testArrayOfStrings", testArrayOfStrings),
            ("testPartiallyInvalidArrayOfValues", testPartiallyInvalidArrayOfValues)
        ]
    }

    func testMappingString() {
        struct Test: Mappable {
            let string: String
            init(mapper: Mapper) throws {
                try self.string = mapper.map(from: "string")
            }
        }
        
        let test = try! Test(mapper: Mapper(structuredData: ["string": "Hello"]))
        XCTAssertTrue(test.string == "Hello")
    }
    
    func testMappingMissingKey() {
        struct Test: Mappable {
            let string: String
            init(mapper: Mapper) throws {
                try self.string = mapper.map(from: "foo")
            }
        }
        
        let test = try? Test(mapper: Mapper(structuredData: [:]))
        XCTAssertNil(test)
    }
    
    func testFallbackMissingKey() {
        struct Test: Mappable {
            let string: String
            init(mapper: Mapper) throws {
                self.string = mapper.map(optionalFrom: "foo") ?? "Hello"
            }
        }
        
        let test = try! Test(mapper: Mapper(structuredData: [:]))
        XCTAssertTrue(test.string == "Hello")
    }
    
    func testArrayOfStrings() {
        struct Test: Mappable {
            let strings: [String]
            init(mapper: Mapper) throws {
                try self.strings = mapper.map(arrayFrom: "strings")
            }
        }
        let test = try! Test(mapper: Mapper(structuredData: ["strings": ["first", "second"]]))
        XCTAssertEqual(test.strings.count, 2)
    }
    
    func testPartiallyInvalidArrayOfValues() {
        struct Test: Mappable {
            let strings: [String]
            init(mapper: Mapper) throws {
                try self.strings = mapper.map(arrayFrom: "strings")
            }
        }
        let test = try! Test(mapper: Mapper(structuredData: ["strings": ["first", "second", 3]]))
        XCTAssertEqual(test.strings.count, 2)
    }
    
}
