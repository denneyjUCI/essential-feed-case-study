//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/5/23.
//

import Foundation

public final class FeedPresenter {

    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for feed view")
    }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
    
}

