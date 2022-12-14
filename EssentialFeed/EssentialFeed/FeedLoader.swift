//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 12/13/22.
//

import Foundation

protocol FeedLoader {
    func loadFeed(completion: @escaping ([FeedItem]) -> Void)
}
