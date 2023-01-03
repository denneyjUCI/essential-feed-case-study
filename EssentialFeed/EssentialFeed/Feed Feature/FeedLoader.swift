//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 12/13/22.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error> 

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
