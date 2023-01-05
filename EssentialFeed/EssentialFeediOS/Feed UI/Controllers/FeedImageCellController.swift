//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/4/23.
//

import UIKit

final class FeedImageCellController {
    private let viewModel: FeedImageViewModel

    init(viewModel: FeedImageViewModel) {
        self.viewModel = viewModel
    }

    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        viewModel.loadImage()
        return cell
    }

    private func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description

        cell.onRetry = viewModel.loadImage

        viewModel.onImageChange = { [weak cell] image in
            cell?.feedImageView.image = image
        }

        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            if isLoading {
                cell?.feedImageContainer.startShimmering()
            } else {
                cell?.feedImageContainer.stopShimmering()
            }
        }

        viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            cell?.imageRetryButton.isHidden = !shouldRetry
        }

        return cell
    }

    func preload() {
        viewModel.loadImage()
    }

    func cancelLoad() {
        viewModel.cancelImageLoad()
    }
}
