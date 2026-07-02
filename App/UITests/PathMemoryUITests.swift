import XCTest

final class PathMemoryUITests: XCTestCase {
    @MainActor
    func testLaunchAndNavigateToGame() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Path Memory"].waitForExistence(timeout: 5))
        app.buttons["Play"].tap()
        XCTAssertTrue(app.staticTexts["Game"].waitForExistence(timeout: 5))
    }
}
