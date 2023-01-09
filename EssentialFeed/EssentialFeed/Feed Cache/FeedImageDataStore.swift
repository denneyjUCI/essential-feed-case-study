//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/9/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
