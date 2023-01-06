import XCTest

final class FeedImagePresenter {
    init(view: Any) {
        
    }
}

final class FeedImagePresenterTests: XCTestCase {

    func test_init_sendsNoMessagesToViews() {
        let view = ViewSpy()

        _ = FeedImagePresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty)
    }

    private class ViewSpy {
        var messages = [Any]()
    }

}
