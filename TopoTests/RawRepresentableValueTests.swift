//
//  RawRepresentableValueTests.swift
//  Topo
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import Topo

class RawRepresentableValueTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
        let test = try! Test(map: Mapper(interchangeData: ["suit": "barney"]))
        XCTAssertEqual(test.suit, Suits.Barney)
    }
    
    func testRawRepresentableNumber() {
        enum Value: String {
            case first
        }
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["value": "first"]))
        XCTAssertEqual(test.value, Value.first)
    }

}
