import XCTest

extension XCUIApplication {
    func statusBarItem() -> XCUIElement {
        menuBars.statusItems["home"]
    }
    
    @discardableResult
    func wait(for state: XCUIApplication.State, timeout: Timeout = .test) -> Bool {
        wait(for: state, timeout: timeout.rawValue)
    }
    
    func statusBarMenu() -> XCUIElement {
        menuBars.statusItems.menus["menu extra menu"]
    }

    func clickStatusItem() {
        repeat {
            NSLog(menuBars.statusItems["home"].debugDescription)
            NSLog(menuBars.statusItems.debugDescription)
            NSLog("attemp to click on status bar item")
            statusBarItem().clickView()
        } while !statusBarMenu().waitForExistence(timeout: Timeout.test.rawValue)
    }
    
    func wait(until newState: XCUIApplication.State,
              timeout: Timeout = .test,
              _ reason: String = "waiting for app state, ",
              file: StaticString = #file,
              line: UInt = #line) {
        XCTAssertTrue(
            wait(for: newState, timeout: timeout.rawValue),
            reason + " got \(state.rawValue)",
            file: file,
            line: line
        )
    }
}
