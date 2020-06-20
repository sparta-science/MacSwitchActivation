import XCTest

class SwitchActivationUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testStartingAsRegular() throws {
        app.launchArguments = ["-accessory", "NO"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5),
                      "should be running in foreground")
        XCTAssertEqual(app.windows.count, 1, "should show main window")
    }
    
    func testStartingAsAccessory() throws {
        app.launchArguments = ["-accessory", "YES"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5),
                      "should be running in background, was: \(app.state.rawValue)")
        XCTAssertEqual(app.windows.count, 0, "should show main window")
    }
}
