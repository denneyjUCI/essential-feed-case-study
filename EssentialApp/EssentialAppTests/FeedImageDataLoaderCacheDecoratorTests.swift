//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Jonathan Denney on 1/10/23.
//

import XCTest
import EssentialFeed

final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
}

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

    // MARK: - Helpers
    func makeSUT(result: FeedImageDataLoader.Result, file: StaticString = #filePath, line: UInt = #line) -> FeedImageDataLoader {
        let loader = FeedImageDataLoaderStub(result: result)
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
