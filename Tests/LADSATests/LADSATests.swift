import XCTest
@testable import LADSA

final class LADSATests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LADSA().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
