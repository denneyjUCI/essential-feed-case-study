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
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)

        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.refreshController = refreshController
        
        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(controller: feedController, imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(refreshController))

        return feedController
    }
}
