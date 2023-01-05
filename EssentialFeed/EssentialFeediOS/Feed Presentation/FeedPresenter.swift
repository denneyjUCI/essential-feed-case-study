//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/5/23.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void

    private let feedLoader: FeedLoader
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var view: FeedView?
    weak var loadingView: FeedLoadingView?

    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load() { [weak self] result in
            if let feed = try? result.get() {
                self?.view?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
