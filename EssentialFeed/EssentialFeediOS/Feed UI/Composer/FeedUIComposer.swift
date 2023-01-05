//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/4/23.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)

        return feedController
    }

    private static func adaptFeedToCellControllers(forwardingTo feedController: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak feedController] feed in
            feedController?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: loader)
            }
        }
    }
}
