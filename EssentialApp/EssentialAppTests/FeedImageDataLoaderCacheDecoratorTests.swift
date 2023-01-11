//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Jonathan Denney on 1/10/23.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTests {

    func test_loadImageData_succeedsOnLoaderSuccess() {
        let result = Data("result".utf8)
        let sut = makeSUT(result: .success(result))

        expect(sut, toCompleteWith: .success(result))
    }

    func test_loadImageData_failsOnLoaderFailure() {
        let sut = makeSUT(result: .failure(anyNSError()))

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }

    func test_loadImageData_cachesImageDataOnLoaderSuccess() {
        let data = Data("result".utf8)
        let url = anyURL()
        let cache = CacheSpy()
        let sut = makeSUT(result: .success(data), cache: cache)

        let _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(cache.messages, [.save(data, for: url)])
    }

    func test_loadImageData_doesNotCacheImageDataOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(result: .failure(anyNSError()), cache: cache)

        let _ = sut.loadImageData(from: anyURL()) { _ in }

        XCTAssertEqual(cache.messages, [])
    }

    // MARK: - Helpers
    func makeSUT(result: FeedImageDataLoader.Result, cache: CacheSpy = .init(), file: StaticString = #filePath, line: UInt = #line) -> FeedImageDataLoader {
        let loader = FeedImageDataLoaderStub(result: result)
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    class CacheSpy: FeedImageDataCache {
        enum Message: Equatable {
            case save(Data, for: URL)
        }

        private(set) var messages = [Message]()

        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(data, for: url))
        }
    }
}
