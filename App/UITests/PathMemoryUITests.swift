import XCTest

final class PathMemoryUITests: XCTestCase {
    @MainActor
    func testLaunchAndNavigateToGame() {
        let app = XCUIApplication()
        app.launch()

        let play = app.buttons["Play"]
        XCTAssertTrue(play.waitForExistence(timeout: 5))
        play.tap()

        XCTAssertTrue(app.staticTexts["Memorize!"].waitForExistence(timeout: 5))
    }
}
