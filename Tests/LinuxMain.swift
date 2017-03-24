import XCTest
@testable import MapperTests

extension InMapperTests {
    static var allTests = [
        ("testPrimitiveMapping", testPrimitiveMapping),
        ("testBasicNesting", testBasicNesting),
        ("testFailNoValue", testFailNoValue),
        ("testFailWrongType", testFailWrongType),
        ("testFailRepresentAsArray", testFailRepresentAsArray),
        ("testArrayOfMappables", testArrayOfMappables),
        ("testEnumMapping", testEnumMapping),
        ("testEnumArrayMapping", testEnumArrayMapping),
        ("testEnumFail", testEnumFail),
        ("testBasicMappingWithContext", testBasicMappingWithContext),
        ("testContextInference", testContextInference),
        ("testArrayMappingWithContext", testArrayMappingWithContext),
        ("testUsingContext", testUsingContext),
        ("testDeep", testDeep),
        ("testFlatArray", testFlatArray),
        ("testAdvancedEnum", testAdvancedEnum),
        ("testExternalMappable", testExternalMappable),
        ("testDateMapping", testDateMapping),
        ]
}
extension OutMapperTests {
    static var allTests = [
        ("testPrimitiveTypesMapping", testPrimitiveTypesMapping),
        ("testBasicNesting", testBasicNesting),
        ("testArrayOfMappables", testArrayOfMappables),
        ("testEnumMappng", testEnumMappng),
        ("testEnumArrayMapping", testEnumArrayMapping),
        ("testBasicMappingWithContext", testBasicMappingWithContext),
        ("testContextInference", testContextInference),
        ("testArrayMappingWithContext", testArrayMappingWithContext),
        ("testUsingContext", testUsingContext),
        ("testExternalMappable", testExternalMappable),
        ("testDateMapping", testDateMapping),
        ]
}
extension PerformanceTests {
    static var allTests = [
        ("testPerformancePrim", testPerformancePrim),
        ("testPerformanceUnsafe", testPerformanceUnsafe),
        ("testPerformanceDirect", testPerformanceDirect),
        ]
}

XCTMain([
    testCase(InMapperTests.allTests),
    testCase(OutMapperTests.allTests),
//    testCase(PerformanceTests.allTests),
])
