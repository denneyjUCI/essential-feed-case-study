//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Jonathan Denney on 1/4/23.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {

    func simulateRetryAction() {
        imageRetryButton.simulateTap()
    }

    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }

    var isShowingImageLoadingIndicator: Bool {
        return feedImageContainer.isShimmering
    }

    var isShowingRetryAction: Bool {
        return !imageRetryButton.isHidden
    }

    var locationText: String? {
        locationLabel.text
    }

    var descriptionText: String? {
        descriptionLabel.text
    }

    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }
}
