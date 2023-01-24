//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/10/23.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
