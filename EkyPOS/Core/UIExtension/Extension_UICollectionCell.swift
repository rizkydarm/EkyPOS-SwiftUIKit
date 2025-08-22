import UIKit

extension UICollectionViewCell {
    
    
    // Method to add the tap animation and the closure callback
    func animateOnTouch() {
        let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapRecognizer.minimumPressDuration = 0.01 // Detect immediate tap
        tapRecognizer.delaysTouchesBegan = false
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            // Shrink cell when touch begins
            animateCell(scale: 0.95) // Shrink to 95% of original size
        case .ended, .cancelled:
            // Return to normal size with ease-out effect when touch ends
            animateCell(scale: 1.0) // Return to original size
            
        case .changed:
            break // Do nothing while the touch is changing (optional)
        default:
            break
        }
    }
    
    internal func animateCell(scale: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    // Key for associated object to store the closure
    private struct AssociatedKeys {
        static var didTapKey = "didTapKey"
    }

}

