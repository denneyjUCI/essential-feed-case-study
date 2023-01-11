//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/10/23.
//

import Foundation

public protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
