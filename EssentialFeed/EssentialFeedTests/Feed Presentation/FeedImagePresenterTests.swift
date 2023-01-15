import XCTest
import EssentialFeed

final class FeedImagePresenterTests: XCTestCase {

    func test_init_sendsNoMessagesToViews() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty)
    }

    func test_map_createsViewModel() {
        let image = uniqueImage()

        let viewModel = FeedImagePresenter<ViewSpy, AnyImage>.map(image)

        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
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

        sut.didFinishLoadingImageData(with: Data(), for: model)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, model.description)
        XCTAssertEqual(message?.location, model.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }

    func test_didFinishLoadingImageData_displaysImageOnImageTransformationSuccess() {
        let model = uniqueImage()
        let data = Data()
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })

        sut.didFinishLoadingImageData(with: data, for: model)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, model.description)
        XCTAssertEqual(message?.location, model.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertEqual(message?.image, transformedData)
    }

    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let model = uniqueImage()
        let (sut, view) = makeSUT()

        sut.didFinishLoadingImageData(with: anyNSError(), for: model)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, model.description)
        XCTAssertEqual(message?.location, model.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }
    // MARK: - Helpers

    private func makeSUT(
        imageTransformer: @escaping (Data) -> AnyImage? = { _ in return nil },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        return (sut, view)
    }

    private var fail: (Data) -> AnyImage? {
        return { _ in nil }
    }

    private struct AnyImage: Equatable {}

    private class ViewSpy: FeedImageView {
        enum Message: Equatable {
            case display(isLoading: Bool)
        }
        private(set) var messages = [FeedImageViewModel<AnyImage>]()

        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
    }

}
