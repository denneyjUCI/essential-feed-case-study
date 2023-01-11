//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/10/23.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
