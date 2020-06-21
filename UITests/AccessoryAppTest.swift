import XCTest

/**
 Accessory app menu is NOT clickable
 trying to click cause "Failed to find parent of element"
 even when app main menu is visible
*/
class AccessoryAppTest: XCTestCase {
    let app = XCUIApplication()
    lazy var processId = app.value(forKeyPath: "_applicationImpl._currentProcess._processID") as! Int
    lazy var menuBarsQuery = app.menuBars
    lazy var mainMenu = menuBarsQuery["main menu"]
    lazy var menuBarStatusItem = menuBarsQuery.statusItems["home"]
    var failedAsExpected = false
    var expectedFailureAtLine: Int?

    func testAccessingMenuCauseFailure() throws {
        app.launchArguments = ["-startAsAccessory", "YES"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5),
                      "should be running in background, was: \(app.state.rawValue)")
        XCTAssertEqual(app.windows.count, 0, "should not show window")
        showMainWindowAndInteract()
        XCTAssertTrue(mainMenu.exists)
        let appMenuItem = mainMenu.menuBarItems["SwitchActivation"]
        XCTAssertTrue(appMenuItem.exists)
        XCTAssertEqual(appMenuItem.identifier, "app menu item")
        expectedFailureAtLine = #line; _ = appMenuItem.isHittable
        addTeardownBlock {
            XCTAssertTrue(self.failedAsExpected)
        }
    }
    
    let anotherApp = XCUIApplication(url: URL(fileURLWithPath: "/Applications/Safari.app"))
    var anotherAppWasRunning: Bool?

    override func setUpWithError() throws {
        continueAfterFailure = false
        let running: [XCUIApplication.State] = [.runningBackground, .runningForeground]
        anotherAppWasRunning = running.contains(anotherApp.state)
        anotherApp.activate()
    }

    override func tearDownWithError() throws {
        app.terminate()
        if anotherAppWasRunning == false {
            anotherApp.terminate()
        }
    }

    func showMainWindowAndInteract() {
        menuBarStatusItem.click()
        app.menuItems["Show Main Window"].click()
        
        let window = app.windows["Window"]
        let textField = window.children(matching: .textField).element
        textField.typeText("abc")
        textField.typeKey("a", modifierFlags:.command)
        textField.typeKey("c", modifierFlags:.command)
    }
    
    func verifyExpectedFailure(withDescription description: String) {
        XCTAssertTrue(description.hasPrefix("Failed to hit test MenuBarItem, {{45.0, 0.0}, {136.0, 22.0}}, "
            + "identifier: 'app menu item', title: 'SwitchActivation', label: 'first app menu item' at point {"))
        XCTAssertTrue(description.contains("}: found AX element pid: \(processId), token:"))
        XCTAssertTrue(description.hasSuffix(" which is from the same process but cannot be mapped using AX data: Failed to find parent of element Application, pid: \(processId), title: \'SwitchActivation\', Disabled, lookup returned nil or invalid object (null)"))
        NSLog("expected failure: \(description)")
    }
    
    override func recordFailure(withDescription description: String, inFile filePath: String, atLine lineNumber: Int, expected: Bool) {
        if lineNumber == expectedFailureAtLine, filePath == #file, expected {
            verifyExpectedFailure(withDescription: description)
            failedAsExpected = true
        } else {
            super.recordFailure(withDescription: description, inFile: filePath, atLine: lineNumber, expected: true)
        }
    }
   
}
