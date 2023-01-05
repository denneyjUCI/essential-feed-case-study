//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/5/23.
//

import Foundation
import EssentialFeed

protocol FeedImageView {
    associatedtype Image

    func display(_ viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?

    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }

    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            isLoading: true,
            shouldRetry: false,
            image: nil))
    }

    private struct InvalidImageData: Error {}

    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageData(), for: model)
        }

        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            isLoading: false,
            shouldRetry: false,
            image: image))
    }

    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            isLoading: false,
            shouldRetry: true,
            image: nil))
    }
}
