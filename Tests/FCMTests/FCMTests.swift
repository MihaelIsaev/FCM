import XCTest
@testable import FCM

final class FCMTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FCM().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
