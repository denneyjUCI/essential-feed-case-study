//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/4/23.
//

import UIKit
import EssentialFeed

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {

    private var onViewIsAppearing: ((ListViewController) -> Void)?
    public var onRefresh: (() -> Void)?

    private(set) public var errorView = ErrorView()

    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = { .init(tableView: tableView) { tableView, index, controller in
        return controller.dataSource.tableView(tableView, cellForRowAt: index)
    }
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
        configureErrorView()
        configureTraitCollectionObservers()

        onViewIsAppearing = { vc in
            vc.onViewIsAppearing = nil
            vc.refresh()
        }
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        onViewIsAppearing?(self)
    }

    private func configureTraitCollectionObservers() {
        registerForTraitChanges(
            [UITraitPreferredContentSizeCategory.self]
        ) { (self: Self, previous: UITraitCollection) in
            self.tableView.reloadData()
        }
    }

    private func configureErrorView() {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(errorView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            errorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.topAnchor.constraint(equalTo: errorView.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }

        tableView.tableHeaderView = container
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }

    @IBAction private func refresh() {
        onRefresh?()
    }

    public func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }

        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot)
        }
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        if let message = viewModel.message {
            refreshControl?.attributedTitle = .init(string: message)
        }
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView.message = viewModel.message
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.dataSourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.dataSourcePrefetching
            dsp?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
        }
    }

    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }

}
