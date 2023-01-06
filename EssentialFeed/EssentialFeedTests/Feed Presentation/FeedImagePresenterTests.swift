import XCTest
import EssentialFeed

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let isLoading: Bool
    let shouldRetry: Bool
    let image: Any?

    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    func display(_ viewModel: FeedImageViewModel)
}

final class FeedImagePresenter {
    private let view: FeedImageView
    init(view: FeedImageView) {
        self.view = view
    }

    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            isLoading: true,
            shouldRetry: false,
            image: nil))
    }
}

final class FeedImagePresenterTests: XCTestCase {

    func test_init_sendsNoMessagesToViews() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty)
    }

    func test_didStartLoadingImageData_sendsLoadingMessage() {
        let (sut, view) = makeSUT()
        let model = uniqueImage()

        sut.didStartLoadingImageData(for: model)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, model.description)
        XCTAssertEqual(message?.location, model.location)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: FeedImageView {
        enum Message: Equatable {
            case display(isLoading: Bool)
        }
        private(set) var messages = [FeedImageViewModel]()

        func display(_ model: FeedImageViewModel) {
            messages.append(model)
        }
    }

}
