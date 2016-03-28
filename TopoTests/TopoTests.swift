//
//  TopoTests.swift
//  TopoTests
//
//  Created by Oleg Dreyman on 27.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import Topo

class TopoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
        
    func testArrays() {
        struct Test: Mappable {
            var ints: [Int]
            init(map: Mapper) throws {
                try self.ints = map.fromArray("ints")
            }
        }
        
        let interchangeData: InterchangeData = [
            "ints": [1, 5, 7, 9, 11]
        ]
        print(interchangeData)
        let test = try! Test(map: Mapper(interchangeData: interchangeData))
        XCTAssertEqual(test.ints, [1, 5, 7, 9, 11])
    }
    
}
