//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/5/23.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
