//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/5/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
