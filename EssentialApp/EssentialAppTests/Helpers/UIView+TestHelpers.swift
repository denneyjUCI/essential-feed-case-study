//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Jonathan Denney on 1/12/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
}
