//
//  FeedViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Jonathan Denney on 1/4/23.
//

import UIKit
import EssentialFeediOS

extension ListViewController {

    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        tableView.frame = .init(origin: .zero, size: .init(width: 1, height: 1))
    }
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    var errorMessage: String? {
        return errorView.message
    }

    func simulateErrorViewTap() {
        errorView.simulateTap()
    }

    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }

    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }

        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

}

extension ListViewController {
    func numberOfRenderedComments() -> Int {
        numberOfRows(in: commentsSection)
    }

    func commentView(at index: Int) -> ImageCommentCell? {
        guard numberOfRenderedComments() > index else {
            return nil
        }

        return cell(row: index, section: commentsSection) as? ImageCommentCell
    }

    func commentMessage(at index: Int) -> String? {
        commentView(at: index)?.messageLabel.text
    }

    func commentDate(at index: Int) -> String? {
        commentView(at: index)?.dateLabel.text
    }
    
    func username(at index: Int) -> String? {
        commentView(at: index)?.usernameLabel.text
    }

    private var commentsSection: Int {
        0
    }

}

extension ListViewController {
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }

    func numberOfRenderedFeedImageViews() -> Int {
        numberOfRows(in: feedImagesSection)
    }

    func feedImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedImageViews() > row else {
            return nil
        }
        
        return cell(row: row, section: feedImagesSection) as? FeedImageCell
    }

    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didSelectRowAt:index)
    }

    func simulateLoadMoreFeedAction() {
        guard let cell = cell(row: 0, section: loadMoreSection) else { return }

        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: loadMoreSection)
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: index)
    }

    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }

    func simulateFeedImageViewNearVisible(at index: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: index, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateFeedImageViewNotNearVisible(at index: Int) {
        simulateFeedImageViewNearVisible(at: index)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: index, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

        return view
    }

    private var feedImagesSection: Int { 0 }
    private var loadMoreSection: Int { 1 }
}
