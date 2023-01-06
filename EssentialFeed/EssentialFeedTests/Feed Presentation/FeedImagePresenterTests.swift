import XCTest

final class FeedImagePresenter {
    init(view: Any) {

    }
}

final class FeedImagePresenterTests: XCTestCase {

    func test_init_sendsNoMessagesToViews() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy {
        var messages = [Any]()
    }

}
