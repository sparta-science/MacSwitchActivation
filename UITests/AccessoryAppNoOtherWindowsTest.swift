import XCTest

/**
 Accessory app menu is clickable when there are no other apps
 */
class AccessoryAppNoOtherWindowsTest: XCTestCase {
    func skipTestWhenThereAreOtherAppsWithWindows() throws {
        let regularApps = NSWorkspace.shared.runningApplications.filter {
            $0.activationPolicy == .regular
            && $0.bundleIdentifier != "com.apple.finder"
        }
        try XCTSkipUnless(regularApps.isEmpty, "there other apps: \(regularApps)")
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        try skipTestWhenThereAreOtherAppsWithWindows()
    }

    let app = XCUIApplication()
    lazy var menuBarsQuery = app.menuBars
    lazy var mainMenu = menuBarsQuery["main menu"]
    lazy var menuBarStatusItem = menuBarsQuery.statusItems["home"]

    func testMainMenuWorksWhenNoOtherAppsAreRunning() throws {
        app.launchArguments = ["-startAsAccessory", "YES"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5),
                      "should be running in background, was: \(app.state.rawValue)")
        XCTAssertEqual(app.windows.count, 0, "should not show window")
        showMainWindowAndInteract()
        verifyMenuWorks()
    }
    
    func showMainWindowAndInteract() {
        app.activate()
        menuBarStatusItem.clickView()
        app.menuItems["Show Main Window"].click()
        
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
    
    override func tearDownWithError() throws {
        app.terminate()
    }
}
