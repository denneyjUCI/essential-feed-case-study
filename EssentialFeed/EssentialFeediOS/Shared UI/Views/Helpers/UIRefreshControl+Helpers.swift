//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/5/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
        isHidden = !isRefreshing
    }
}
