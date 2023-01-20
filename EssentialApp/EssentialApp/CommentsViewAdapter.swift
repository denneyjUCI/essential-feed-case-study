//
//  CommentsViewAdapter.swift
//  EssentialApp
//
//  Created by Jonathan Denney on 1/20/23.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?

    public init(controller: ListViewController) {
        self.controller = controller
    }

    public func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}
