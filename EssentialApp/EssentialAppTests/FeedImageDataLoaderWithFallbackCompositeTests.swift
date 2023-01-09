import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {

    private let primary: FeedImageDataLoader
    private let fallback: FeedImageDataLoader
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?

        func cancel() {
            wrapped?.cancel()
        }
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url) { result in
                    switch result {
                    case .success:
                        completion(result)
                    default:
                        break
                    }
                }
            }
        }
        return task
    }

}

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

    func test_loadImageData_deliversPrimaryDataOnPrimarySuccess() {
        let primaryData = Data("primary".utf8)
        let fallbackData = Data("fallback".utf8)
        let sut = makeSUT(primaryResult: .success(primaryData), fallbackResult: .success(fallbackData))

        let exp = expectation(description: "Wait for image load completion")
        _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, primaryData)

            case .failure:
                XCTFail("Expected load success, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_loadImageData_deliversFallbackDataOnPrimarySuccess() {
        let fallbackData = Data("fallback".utf8)
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackData))

        let exp = expectation(description: "Wait for image load completion")
        _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, fallbackData)

            case .failure:
                XCTFail("Expected load success, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    // MARK: - Helpers
    private func makeSUT(primaryResult: FeedImageDataLoader.Result, fallbackResult: FeedImageDataLoader.Result, file: StaticString = #filePath, line: UInt = #line) -> FeedImageDataLoaderWithFallbackComposite {
        let primaryLoader = LoaderStub(result: primaryResult)
        let fallbackLoader = LoaderStub(result: fallbackResult)
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, potential memory leak!", file: file, line: line)
        }
    }

    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

    private class LoaderStub: FeedImageDataLoader {
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {}
        }
        private let result: FeedImageDataLoader.Result
        init(result: FeedImageDataLoader.Result) {
            self.result = result
        }

        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            completion(result)
            return Task()
        }
    }
}
