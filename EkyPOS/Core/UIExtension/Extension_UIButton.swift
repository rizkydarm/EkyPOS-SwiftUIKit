//
//  AssociatedKeys.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import UIKit

extension UIButton {
    private struct AssociatedKeys {
        static var feedbackGeneratorKey = "feedbackGeneratorKey"
    }
    
    // Associated property for haptic feedback
    private var feedbackGenerator: UIImpactFeedbackGenerator? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.feedbackGeneratorKey) as? UIImpactFeedbackGenerator
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.feedbackGeneratorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Enables bounce animation with optional haptic feedback
    func enableBounceAnimation(enableHaptic: Bool = true) {
        if enableHaptic {
            feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        }
        
        addTarget(self, action: #selector(bounceAnimatePress), for: .touchDown)
        addTarget(self, action: #selector(bounceAnimateRelease), for: [.touchUpInside, .touchCancel])
    }
    
    @objc private func bounceAnimatePress() {
        feedbackGenerator?.impactOccurred()
        bounceAnimateTransform(scale: 0.96)
    }
    
    @objc private func bounceAnimateRelease() {
        bounceAnimateTransform(scale: 1.0)
    }
    
    private func bounceAnimateTransform(scale: CGFloat) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 10,
            options: [.allowUserInteraction, .curveEaseOut],
            animations: {
                self.transform = scale == 1.0 ? .identity : CGAffineTransform(scaleX: scale, y: scale)
            }
        )
    }
}
