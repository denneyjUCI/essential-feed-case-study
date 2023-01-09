import XCTest
import EssentialFeed

final class CacheFeedImageDataUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_saveImageDataForURL_requestsImageInsertion() {
        let (sut, store) = makeSUT()
        let data = anyData()
        let url = anyURL()

        sut.save(data, for: url) { _ in }

        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
