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
    private let imageTransformer: (Data) -> Any?

    init(view: FeedImageView, imageTransformer: @escaping (Data) -> Any?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }

    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            isLoading: true,
            shouldRetry: false,
            image: nil))
    }

    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            isLoading: false,
            shouldRetry: true,
            image: imageTransformer(data)))
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

    func test_didFinishLoadingImageData_displaysRetryOnImageTransformationError() {
        let (sut, view) = makeSUT(imageTransformer: fail)
        let model = uniqueImage()
        let data = Data()

        sut.didFinishLoadingImageData(with: data, for: model)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, model.description)
        XCTAssertEqual(message?.location, model.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }

    // MARK: - Helpers

    private func makeSUT(imageTransformer: @escaping (Data) -> Any? = { _ in return nil }, file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        return (sut, view)
    }

    private var fail: (Data) -> Any? {
        return { _ in nil }
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
