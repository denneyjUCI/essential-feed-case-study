//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/4/23.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
