//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/6/23.
//

import Foundation

public protocol FeedImageView {
    associatedtype Image

    func display(_ viewModel: FeedImageViewModel)
}

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(description: image.description,
                           location: image.location)
    }
}
