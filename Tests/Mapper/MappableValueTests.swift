// MappableValueTests.swift
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
        let structuredData: StructuredData = [
            "nest": ["string": "hello"]
        ]
        let test = try! Test(map: Mapper(structuredData: structuredData))
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
        let structuredData: StructuredData = ["nest": ["strong": "er"]]
        let test = try? Test(map: Mapper(structuredData: structuredData))
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
        let structuredData: StructuredData = ["nest": ["string": "zewo"]]
        let test = try! Test(map: Mapper(structuredData: structuredData))
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
        let structuredData: StructuredData = ["nest": ["strong": "er"]]
        let test = try! Test(map: Mapper(structuredData: structuredData))
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
        let test = try! Test(map: Mapper(structuredData: ["nested": [["string": "fire"], ["string": "sun"]]]))
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
        let test = try! Test(map: Mapper(structuredData: ["nested": [["string": 1], ["string": 1]]]))
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
        let test = try? Test(map: Mapper(structuredData: ["hested": [["strong": "fire"], ["strong": "sun"]]]))
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
        let test = try! Test(map: Mapper(structuredData: ["nested": [["string": 1], ["string": "fire"]]]))
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
        let test = try! Test(map: Mapper(structuredData: ["nested": [["string": "ring"], ["string": "fire"]]]))
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
        let test = try! Test(map: Mapper(structuredData: []))
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
        let test = try! Test(map: Mapper(structuredData: ["nested": [["strong": 3], ["strong": 5]]]))
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
        let test = try! Test(map: Mapper(structuredData: ["nested": [["string": 1], ["string": "fire"]]]))
        XCTAssertEqual(test.nested!.count, 1)
    }
}
