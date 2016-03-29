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
        enum Value: Double {
            case first = 1.0
        }
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: ["value": 1.0]))
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
        let test = try? Test(map: Mapper(interchangeData: ["value": 1]))
        XCTAssertNil(test)
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
        let test = try? Test(map: Mapper(interchangeData: .nullValue))
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
        let test = try! Test(map: Mapper(interchangeData: .nullValue))
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
        let test = try! Test(map: Mapper(interchangeData: ["value": 1.0]))
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
        let test = try! Test(map: Mapper(interchangeData: ["value": "cike"]))
        XCTAssertNil(test.value)
    }
    
    func testRawRepresentableArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]
            init(map: Mapper) throws {
                try self.barneys = map.fromArray("barneys")
            }
        }
        let barneysContent: InterchangeData = ["barneys": ["legendary", "stinson", "awesome"]]
        let test = try! Test(map: Mapper(interchangeData: barneysContent))
        XCTAssertEqual(test.barneys, [Barney.legendary, Barney.stinson, Barney.awesome])
    }
    
    func testRawRepresentablePartialArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]
            init(map: Mapper) throws {
                try self.barneys = map.fromArray("barneys")
            }
        }
        let barneysContent: InterchangeData = ["barneys": ["legendary", "stinson", "captain"]]
        let test = try! Test(map: Mapper(interchangeData: barneysContent))
        XCTAssertEqual(test.barneys, [Barney.legendary, Barney.stinson])
    }
    
    func testRawRepresentableOptionalArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]?
            init(map: Mapper) throws {
                self.barneys = map.optionalFromArray("barneys")
            }
        }
        let test = try! Test(map: Mapper(interchangeData: .nullValue))
        XCTAssertNil(test.barneys)
    }
    
    func testRawRepresentableExistingOptionalArray() {
        enum Barney: String {
            case stinson, awesome, legendary
        }
        struct Test: Mappable {
            let barneys: [Barney]?
            init(map: Mapper) throws {
                self.barneys = map.optionalFromArray("barneys")
            }
        }
        let barneysContent: InterchangeData = ["barneys": ["legendary", "stinson", "awesome"]]
        let test = try! Test(map: Mapper(interchangeData: barneysContent))
        XCTAssertEqual(test.barneys!, [Barney.legendary, Barney.stinson, Barney.awesome])
    }

}
