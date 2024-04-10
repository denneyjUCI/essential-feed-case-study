//
//  CoreDataFeedStore+FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/9/23.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    public func retrieve(dataForURL url: URL) throws -> Data? {
        try ManagedFeedImage.data(with: url, in: context)
    }

    public func insert(_ data: Data, for url: URL) throws {
        try ManagedFeedImage.first(with: url, in: context)
            .map { $0.data = data }
            .map(context.save)
    }
}
