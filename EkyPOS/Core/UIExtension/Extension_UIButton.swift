//
//  AssociatedKeys.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//


extension UIButton {
    func addBounceAnimation(
        duration: TimeInterval = 0.2,
        scale: CGFloat = 0.95,
        completion: (() -> Void)? = nil
    ) {
        addTarget(self, action: #selector(animateAdvancedBounce), for: .touchUpInside)
        // Store completion in associated object
        objc_setAssociatedObject(self, &AssociatedKeys.completion, completion, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func animateAdvancedBounce() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    usingSpringWithDamping: 0.4,
                    initialSpringVelocity: 6,
                    options: [.allowUserInteraction],
                    animations: {
                        self.transform = .identity
                    },
                    completion: { _ in
                        if let completion = objc_getAssociatedObject(self, &AssociatedKeys.completion) as? () -> Void {
                            completion()
                        }
                    }
                )
            }
        )
    }
}

private struct AssociatedKeys {
    static var completion: UInt8 = 0
}