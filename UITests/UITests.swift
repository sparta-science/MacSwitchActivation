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
    
    func testStartingAsAccessory() throws {
        app.launchArguments = ["-startAsAccessory", "YES"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5),
                      "should be running in background, was: \(app.state.rawValue)")
        XCTAssertEqual(app.windows.count, 0, "should not show window")
        showMainWindowAndInteract()
        XCTAssertTrue(mainMenu.exists)
        XCTAssertTrue(mainMenu.menuBarItems["SwitchActivation"].exists)
        XCTAssertTrue(mainMenu.menuBarItems["SwitchActivation"].isHittable)
        verifyMenuIsHittable()
    }
}
