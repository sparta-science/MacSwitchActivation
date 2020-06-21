import XCTest

extension XCUIElement {
    func clickView() {
        coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).click()
    }
}
