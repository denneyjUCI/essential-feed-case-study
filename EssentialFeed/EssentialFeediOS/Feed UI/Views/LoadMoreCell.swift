//
//  LoadMoreCell.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/23/23.
//

import UIKit

public class LoadMoreCell: UITableViewCell {

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        contentView.addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: spinner.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: spinner.centerYAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])

        return spinner
    }()

    public var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            if newValue {
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
            }
        }
    }

}
