//
//  XCTestCase+FeedLoader.swift
//  EssentialAppTests
//
//  Created by Jonathan Denney on 1/10/23.
//

import XCTest
import EssentialFeed

protocol FeedLoaderTestCase: XCTestCase {}

extension FeedLoaderTestCase {
    func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: Swift.Result<[FeedImage], Error>, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected \(expectedResult) result, got \(receivedResult) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}

