//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 12/13/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func loadFeed(completion: @escaping (LoadFeedResult) -> Void)
}
