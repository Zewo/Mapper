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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
        XCTAssertTrue(test.nest.string == "hello")
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

}
