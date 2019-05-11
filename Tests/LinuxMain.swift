import XCTest
@testable import AppTests

XCTMain([
    testCase(ArticleTests.allTests),
    testCase(CategoryTests.allTests),
    testCase(UserTests.allTests)
    ])
