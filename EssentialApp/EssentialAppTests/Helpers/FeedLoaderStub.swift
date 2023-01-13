//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Jonathan Denney on 1/10/23.
//

import EssentialFeed

class FeedLoaderStub {
    private let result: Swift.Result<[FeedImage], Error>
    init(result: Swift.Result<[FeedImage], Error>) {
        self.result = result
    }

    func load(completion: @escaping (Swift.Result<[FeedImage], Error>) -> Void) {
        completion(result)
    }
}
