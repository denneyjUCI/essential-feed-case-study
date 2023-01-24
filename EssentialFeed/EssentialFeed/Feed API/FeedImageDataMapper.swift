//
//  FeedImageDataMapper.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/23/23.
//

import Foundation

public final class FeedImageDataMapper {

    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
