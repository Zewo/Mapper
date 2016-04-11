#if os(Linux)

import XCTest
@testable import StructuredDataMapperTestSuite

XCTMain([
	testCase(NormalValueTests.allTests),
	testCase(OptionalValueTests.allTests),
	testCase(RawRepresentableValueTests.allTests)
])

#endif