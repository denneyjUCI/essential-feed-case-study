//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/5/23.
//

import UIKit
import EssentialFeed

final class FeedImageViewModel {
    typealias Observer<T> = (T) -> Void

    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader

    var onImageChange: Observer<UIImage?>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    var onImageLoadingStateChange: Observer<Bool>?

    var hasLocation: Bool {
        model.location != nil
    }

    var location: String? {
        model.location
    }

    var description: String? {
        model.description
    }

    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func loadImage() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        self.task = self.imageLoader.loadImageData(from: self.model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageChange?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        self.onImageLoadingStateChange?(false)
    }

    func cancelImageLoad() {
        task?.cancel()
        task = nil
    }
}
