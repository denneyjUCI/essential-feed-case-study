import XCTest
import EssentialFeediOS
@testable import EssentialApp

final class SceneDelegateTests: XCTestCase {

    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window

        sut.configureWindow()

        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected window to be key and visible")
    }

    func test_configureWindow_configuresRootViewController()  {
        let sut = SceneDelegate()
        sut.window = UIWindow()

        sut.configureWindow()

        let root = sut.window?.rootViewController
        let rootNav = root as? UINavigationController
        let topController = rootNav?.topViewController

        XCTAssertNotNil(rootNav, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead")
    }

}

private class UIWindowSpy: UIWindow {
    var makeKeyAndVisibleCallCount = 0
    override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount += 1
    }
}
