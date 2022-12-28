//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 12/13/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
