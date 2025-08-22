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
        static var originalBackgroundColorKey = "originalBackgroundColorKey"
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
    
    // Associated property to store original background color
    private var originalBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.originalBackgroundColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.originalBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Enables bounce animation with optional haptic feedback
    func enableBounceAnimation(enableHaptic: Bool = true) {
        if enableHaptic {
            feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        }
        
        // Store original background color if not already stored
        if originalBackgroundColor == nil {
            originalBackgroundColor = backgroundColor ?? UIColor.clear
        }
        
        addTarget(self, action: #selector(bounceAnimatePress), for: .touchDown)
        addTarget(self, action: #selector(bounceAnimateRelease), for: .touchUpInside)
        addTarget(self, action: #selector(bounceAnimateRelease), for: .touchUpOutside)
        addTarget(self, action: #selector(bounceAnimateCancel), for: .touchCancel)
    }
    
    @objc private func bounceAnimatePress() {
        feedbackGenerator?.impactOccurred()
        bounceAnimateTransform(scale: 0.96, isPressed: true)
    }
    
    @objc private func bounceAnimateRelease() {
        bounceAnimateTransform(scale: 1.0, isPressed: false)
    }
    
    @objc private func bounceAnimateCancel() {
        // Also animate back to normal when touch is cancelled
        bounceAnimateTransform(scale: 1.0, isPressed: false)
    }
    
    private func bounceAnimateTransform(scale: CGFloat, isPressed: Bool) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 10,
            options: [.allowUserInteraction, .curveEaseOut],
            animations: {
                // Transform animation
                self.transform = scale == 1.0 ? .identity : CGAffineTransform(scaleX: scale, y: scale)
                
                // Background color opacity animation
                if let originalColor = self.originalBackgroundColor {
                    if isPressed {
                        // Make background more transparent when pressed
                        self.backgroundColor = originalColor.withAlphaComponent(0.7)
                    } else {
                        // Restore original background color when released
                        self.backgroundColor = originalColor
                    }
                }
            }
        )
    }
}
