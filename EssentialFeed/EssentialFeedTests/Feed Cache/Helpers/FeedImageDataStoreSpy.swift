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
    private var completions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    private var insertionCompletions = [(FeedImageDataStore.InsertionResult) -> Void]()

    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(dataFor: url))
        completions.append(completion)
    }

    func complete(with error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }

    func complete(with data: Data?, at index: Int = 0) {
        completions[index](.success(data))
    }

    func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
        insertionCompletions.append(completion)
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
}
