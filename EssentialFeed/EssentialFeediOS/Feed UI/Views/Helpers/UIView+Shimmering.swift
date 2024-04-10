//
//  UIView+Shimmering.swift
//  EssentialFeediOS
//
//  Created by Jonathan Denney on 1/4/23.
//

import UIKit

extension UIView {
    public var isShimmering: Bool {
        get {
            return layer.mask?.animation(forKey: shimmerAnimationKey) != nil
        }
        set {
            if newValue {
                startShimmering()
            } else {
                stopShimmering()
            }
        }
    }

    private var shimmerAnimationKey: String {
        return "shimmer"
    }

    func startShimmering() {
        layer.mask = ShimmeringLayer(size: bounds.size)
    }

    func stopShimmering() {
        layer.mask = nil
    }

    private class ShimmeringLayer: CAGradientLayer {
        private var observer: Any?

        convenience init(size: CGSize) {
            self.init()

            let white = UIColor.white.cgColor
            let alpha = UIColor.white.withAlphaComponent(0.7).cgColor
            let width = size.width
            let height = size.height

            colors = [alpha, white, alpha]
            startPoint = CGPoint(x: 0.0, y: 0.4)
            endPoint = CGPoint(x: 1.0, y: 0.6)
            locations = [0.4, 0.5, 0.6]
            frame = CGRect(x: -width, y: 0, width: width * 3, height: height)

            let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
            animation.fromValue = [0.0, 0.1, 0.2]
            animation.toValue = [0.8, 0.9, 1.0]
            animation.duration = 1
            animation.repeatCount = .infinity
            add(animation, forKey: "shimmer")

            observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: { [weak self] _ in
                self?.add(animation, forKey: "shimmer")
            })
        }
    }
}
