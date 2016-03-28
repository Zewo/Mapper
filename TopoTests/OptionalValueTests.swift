//
//  OptionalValueTests.swift
//  Topo
//
//  Created by Oleg Dreyman on 28.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import Topo

final class OptionalValueTests: XCTestCase {

    func testMappingToClass() {
        final class Test: Mappable {
            let string: String
            required init(map: Mapper) throws {
                self.string = map.optionalFrom("string") ?? ""
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["string": "Hello"]))
        XCTAssertEqual(test.string, "Hello")
    }
    
    func testMappingOptionalValue() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                self.string = map.optionalFrom("whiskey")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: .NullValue))
        XCTAssertNil(test.string)
    }
    
    func testMappingOptionalArray() {
        struct Test: Mappable {
            let strings: [String]?
            init(map: Mapper) throws {
                self.strings = map.optionalFromArray("whiskey")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: .NullValue))
        XCTAssertNil(test.strings)
    }
    
    func testMappingOptionalExistingArray() {
        struct Test: Mappable {
            let strings: [String]?
            init(map: Mapper) throws {
                self.strings = map.optionalFromArray("whiskey")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["whiskey": ["lera", "lynn"]]))
        XCTAssertEqual(test.strings!, ["lera", "lynn"])
    }
    
}
