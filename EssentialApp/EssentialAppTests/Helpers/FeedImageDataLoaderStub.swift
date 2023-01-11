//
//  FeedImageDataLoaderStub.swift
//  EssentialAppTests
//
//  Created by Jonathan Denney on 1/10/23.
//

import Foundation
import EssentialFeed

class FeedImageDataLoaderStub: FeedImageDataLoader {
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
