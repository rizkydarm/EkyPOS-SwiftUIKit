import UIKit

class ShrinkCollectionViewCell: UICollectionViewCell {
    
    @IBInspectable var shrinkScale: CGFloat = 0.99
    @IBInspectable var animationDuration: Double = 0.1
    @IBInspectable var opacity: CGFloat = 0.6
    
    private var overlayView: UIView?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Create overlay view if it doesn't exist
        if overlayView == nil {
            overlayView = UIView()
            overlayView?.frame = self.bounds
            overlayView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView?.isUserInteractionEnabled = false
            self.addSubview(overlayView!)
        }
        
        // Set overlay color (UIColor.label adapts to dark mode)
        overlayView?.backgroundColor = UIColor.secondaryLabel.withAlphaComponent(0.1)

        UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: self.shrinkScale, y: self.shrinkScale)
            self.overlayView?.alpha = self.opacity
        }, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateToNormal()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateToNormal()
    }

    private func animateToNormal() {
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform.identity
            self.overlayView?.alpha = 0
        }, completion: { _ in
            // Optionally remove overlay when not needed
            self.overlayView?.removeFromSuperview()
            self.overlayView = nil
        })
    }

    // Make sure to handle layout
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView?.frame = self.bounds
    }
}