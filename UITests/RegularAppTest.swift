import XCTest

/**
 Regular app menu is working as expected
*/
class RegularAppTest: XCTestCase {
    let app = XCUIApplication()
    lazy var menuBarsQuery = app.menuBars
    lazy var mainMenu = menuBarsQuery["main menu"]

    func testMenuWorks() throws {
        app.launchArguments = ["-startAsAccessory", "NO"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5),
                      "should be running in foreground")
        XCTAssertEqual(app.windows.count, 1, "should show main window")
        verifyMenuWorks()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func verifyMenuWorks() {
        mainMenu.menuBarItems["SwitchActivation"].click()
        mainMenu.menus.menuItems["About SwitchActivation"].click()
        XCTAssertTrue(app.staticTexts["Version 1.0 (1)"].waitForExistence(timeout: 1))
    }
}
