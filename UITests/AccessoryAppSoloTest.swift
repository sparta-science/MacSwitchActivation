import XCTest

class AccessoryAppSoloTest: XCTestCase {
    let app = XCUIApplication()
    lazy var menuBarsQuery = app.menuBars
    lazy var mainMenu = menuBarsQuery["main menu"]
    lazy var menuBarStatusItem = menuBarsQuery.statusItems["home"]

    func testAccessingMenuCauseFailure() throws {
        app.launchArguments = ["-startAsAccessory", "YES"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5),
                      "should be running in background, was: \(app.state.rawValue)")
        XCTAssertEqual(app.windows.count, 0, "should not show window")
        showMainWindowAndInteract()
        verifyMenuWorks()
    }
    
    func showMainWindowAndInteract() {
        menuBarStatusItem.click()
        app.menuItems["Show Window"].click()
        
        let window = app.windows["Window"]
        let textField = window.children(matching: .textField).element
        textField.typeText("abc")
        textField.typeKey("a", modifierFlags:.command)
        textField.typeKey("c", modifierFlags:.command)
    }

    func verifyMenuWorks() {
        mainMenu.menuBarItems["SwitchActivation"].click()
        mainMenu.menus.menuItems["About SwitchActivation"].click()
        XCTAssertTrue(app.staticTexts["Version 1.0 (1)"].waitForExistence(timeout: 1))
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        NSWorkspace.shared.runningApplications.forEach {
            let property: [Any] = [
                $0.localizedName!,
                $0.isActive,
                $0.isHidden,
                $0.activationPolicy.rawValue,
                $0.bundleIdentifier ?? "no bundle id",
                $0.bundleURL!.path,
                $0.executableURL!.path,
            ]
            NSLog(property.debugDescription)
        }
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

}
