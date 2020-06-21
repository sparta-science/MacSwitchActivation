import XCTest

enum Timeout: TimeInterval {
    case test = 5
    case launch = 10
    case install = 30
    case network = 60
}

extension XCUIElement {
    func clickView() {
        coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).click()
    }
    @discardableResult
    func waitToBeClickable(timeout: Timeout = .test,
                           file: StaticString = #file,
                           line: UInt = #line) -> XCUIElement {
        let hittable = NSPredicate(format: "hittable == true")
        let becameHittable = XCTNSPredicateExpectation(predicate: hittable, object: self)
        XCTWaiter.wait(
            until: becameHittable,
            timeout: timeout,
            "\(self) has not became hittable, isHittable:\(isHittable)",
            file: file,
            line: line
        )
        return self
    }
}
