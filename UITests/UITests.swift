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
        app.launchArguments = ["-startAsAccessory", "NO"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5),
                      "should be running in foreground")
        XCTAssertEqual(app.windows.count, 1, "should show main window")
        verifyMenuIsHittable()
    }
    
    lazy var mainMenu = menuBarsQuery["main menu"]
    
    func verifyMenuIsHittable() {
        mainMenu.menuBarItems["SwitchActivation"].click()
        mainMenu.menus.menuItems["About SwitchActivation"].click()
        XCTAssertTrue(app.staticTexts["Version 1.0 (1)"].waitForExistence(timeout: 1))
    }
    
    lazy var menuBarsQuery = app.menuBars
    lazy var menuBarStatusItem = menuBarsQuery.statusItems["home"]

    func showMainWindowAndInteract() {
        menuBarStatusItem.click()
        app.menuItems["Show Window"].click()
        
        let window = app.windows["Window"]
        let textField = window.children(matching: .textField).element
        textField.typeText("abc")
        textField.typeKey("a", modifierFlags:.command)
        textField.typeKey("c", modifierFlags:.command)
    }
    
    func verifyExpectedFailure(withDescription description: String) {
        XCTAssertTrue(description.hasPrefix("Failed to hit test MenuBarItem, {{"))
        XCTAssertTrue(description.contains("which is from the same process but cannot be mapped using AX data: Failed to find parent of element Application, pid: "))
        XCTAssertTrue(description.hasSuffix("title: \'SwitchActivation\', Disabled, lookup returned nil or invalid object (null)"))
        NSLog("expected failure: \(description)")
    }
    
    override func recordFailure(withDescription description: String, inFile filePath: String, atLine lineNumber: Int, expected: Bool) {
        if lineNumber == expectedFailure, filePath == #file, expected {
            verifyExpectedFailure(withDescription: description)
        } else {
            super.recordFailure(withDescription: description, inFile: filePath, atLine: lineNumber, expected: true)
        }
    }
    
    var expectedFailure: Int?
    
    func testStartingAsAccessory() throws {
        app.launchArguments = ["-startAsAccessory", "YES"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5),
                      "should be running in background, was: \(app.state.rawValue)")
        XCTAssertEqual(app.windows.count, 0, "should not show window")
        showMainWindowAndInteract()
        XCTAssertTrue(mainMenu.exists)
        XCTAssertTrue(mainMenu.menuBarItems["SwitchActivation"].exists)
        expectedFailure = #line; _ = mainMenu.menuBarItems["SwitchActivation"].isHittable
    }
}
