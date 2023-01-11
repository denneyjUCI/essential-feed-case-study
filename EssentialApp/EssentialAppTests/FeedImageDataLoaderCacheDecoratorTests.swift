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

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {

    func test_loadImageData_succeedsOnLoaderSuccess() {
        let result = Data("result".utf8)
        let loaderStub = LoaderStub(result: .success(result))
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loaderStub)

        expect(sut, toCompleteWith: .success(result))
    }

    func test_loadImageData_failsOnLoaderFailure() {
        let loaderStub = LoaderStub(result: .failure(anyNSError()))
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loaderStub)

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }

    private func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for image load completion")
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
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
