//
//  MappableValueTests.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
import InterchangeData
@testable import InterchangeDataMapper

class MappableValueTests: XCTestCase {

    static var allTests: [(String, MappableValueTests -> () throws -> Void)] {
        return [
            ("testNestedMappable", testNestedMappable),
            ("testNestedInvalidMappable", testNestedInvalidMappable),
            ("testNestedOptionalMappable", testNestedOptionalMappable),
            ("testNestedOptionalInvalidMappable", testNestedOptionalInvalidMappable),
            ("testArrayOfMappables", testArrayOfMappables),
            ("testArrayOfInvalidMappables", testArrayOfInvalidMappables),
            ("testInvalidArrayOfMappables", testInvalidArrayOfMappables),
            ("testArrayOfPartiallyInvalidMappables", testArrayOfPartiallyInvalidMappables),
            ("testExistingOptionalArrayOfMappables", testExistingOptionalArrayOfMappables),
            ("testOptionalArrayOfMappables", testOptionalArrayOfMappables),
            ("testOptionalArrayOfInvalidMappables", testOptionalArrayOfInvalidMappables),
            ("testOptionalArrayOfPartiallyInvalidMappables", testOptionalArrayOfPartiallyInvalidMappables)
        ]
    }

    func testNestedMappable() {
        struct Test: Mappable {
            let nest: Nested
            init(map: Mapper) throws {
                try self.nest = map.from("nest")
            }
        }
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        let interchangeData: InterchangeData = [
            "nest": ["string": "hello"]
        ]
        let test = try! Test(map: Mapper(interchangeData: interchangeData))
        XCTAssertEqual(test.nest.string, "hello")
    }
    
    func testNestedInvalidMappable() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: Nested
            init(map: Mapper) throws {
                try self.nested = map.from("nest")
            }
        }
        let interchangeData: InterchangeData = ["nest": ["strong": "er"]]
        let test = try? Test(map: Mapper(interchangeData: interchangeData))
        XCTAssertNil(test)
    }
    
    func testNestedOptionalMappable() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: Nested?
            init(map: Mapper) throws {
                self.nested = map.optionalFrom("nest")
            }
        }
        let interchangeData: InterchangeData = ["nest": ["string": "zewo"]]
        let test = try! Test(map: Mapper(interchangeData: interchangeData))
        XCTAssertEqual(test.nested!.string, "zewo")
    }
    
    func testNestedOptionalInvalidMappable() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: Nested?
            init(map: Mapper) throws {
                self.nested = map.optionalFrom("nest")
            }
        }
        let interchangeData: InterchangeData = ["nest": ["strong": "er"]]
        let test = try! Test(map: Mapper(interchangeData: interchangeData))
        XCTAssertNil(test.nested)
    }
    
    func testArrayOfMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]
            init(map: Mapper) throws {
                try self.nested = map.arrayFrom("nested")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["nested": [["string": "fire"], ["string": "sun"]]]))
        XCTAssertEqual(test.nested.count, 2)
        XCTAssertEqual(test.nested[1].string, "sun")
    }
    
    func testArrayOfInvalidMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]
            init(map: Mapper) throws {
                try self.nested = map.arrayFrom("nested")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["nested": [["string": 1], ["string": 1]]]))
        XCTAssertTrue(test.nested.isEmpty)
    }
    
    func testInvalidArrayOfMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]
            init(map: Mapper) throws {
                try self.nested = map.arrayFrom("nested")
            }
        }
        let test = try? Test(map: Mapper(interchangeData: ["hested": [["strong": "fire"], ["strong": "sun"]]]))
        XCTAssertNil(test)
    }
    
    func testArrayOfPartiallyInvalidMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]
            init(map: Mapper) throws {
                try self.nested = map.arrayFrom("nested")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["nested": [["string": 1], ["string": "fire"]]]))
        XCTAssertEqual(test.nested.count, 1)
    }
    
    func testExistingOptionalArrayOfMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]?
            init(map: Mapper) throws {
                self.nested = map.optionalArrayFrom("nested")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["nested": [["string": "ring"], ["string": "fire"]]]))
        XCTAssertEqual(test.nested!.count, 2)
    }
    
    func testOptionalArrayOfMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]?
            init(map: Mapper) throws {
                self.nested = map.optionalArrayFrom("nested")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: []))
        XCTAssertNil(test.nested)
    }
    
    func testOptionalArrayOfInvalidMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]?
            init(map: Mapper) throws {
                self.nested = map.optionalArrayFrom("nested")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["nested": [["strong": 3], ["strong": 5]]]))
        XCTAssertTrue(test.nested!.isEmpty)
    }
    
    func testOptionalArrayOfPartiallyInvalidMappables() {
        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        struct Test: Mappable {
            let nested: [Nested]?
            init(map: Mapper) throws {
                self.nested = map.optionalArrayFrom("nested")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["nested": [["string": 1], ["string": "fire"]]]))
        XCTAssertEqual(test.nested!.count, 1)
    }

}
