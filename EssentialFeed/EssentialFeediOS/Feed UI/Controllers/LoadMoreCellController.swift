//
//  LoadMoreCellController.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/23/23.
//

import UIKit
import EssentialFeed

public class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {

    private let cell = LoadMoreCell()
    private let callback: () -> Void
    private var observation: NSKeyValueObservation?
    private var lastOffset: CGPoint = .zero {
        didSet {
            if lastOffset.y > oldValue.y {
                reloadIfNeeded()
            }
        }
    }

    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadIfNeeded()

        observation = tableView.observe(\.contentOffset, options: .new) { [weak self] (tableView, value) in
            guard tableView.isDragging else { return }

            value.newValue.map { self?.lastOffset = $0 }
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        observation = nil
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }

    private func reloadIfNeeded() {
        guard !cell.isLoading else { return }

        callback()
    }
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        cell.message = viewModel.message
    }
}
