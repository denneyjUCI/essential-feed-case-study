//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Jonathan Denney on 1/9/23.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }
    var receivedMessages = [Message]()
    private var retrievalResult: Result<Data?, Error>?
    private var insertionResult: Result<Void,Error>?

    func retrieve(dataForURL url: URL) throws -> Data? {
        receivedMessages.append(.retrieve(dataFor: url))
        return try retrievalResult?.get()
    }

    func complete(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }

    func complete(with data: Data?, at index: Int = 0) {
        retrievalResult = .success(data)
    }

    func insert(_ data: Data, for url: URL) throws {
        receivedMessages.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}
