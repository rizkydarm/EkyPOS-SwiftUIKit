import UIKit

final class FadeTransitionManager: NSObject {
    
    private let duration: TimeInterval
    
    private var operation: UINavigationController.Operation = .push
    
    init(duration: TimeInterval = 0.3) {
        self.duration = duration
    }
    
    private func animatePresent(
        to toVC: UIViewController,
        from fromVC: UIViewController,
        using context: UIViewControllerContextTransitioning
    ) {
        guard let toView = context.view(forKey: .to) else {
            context.completeTransition(false)
            return
        }
        
        // Set up the toView
        toView.alpha = 0.0
        context.containerView.addSubview(toView)
        toView.frame = context.finalFrame(for: toVC)
        
        // Perform the fade animation
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            toView.alpha = 1.0
        }) { finished in
            context.completeTransition(finished)
        }
    }
    
    private func animateDismiss(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        using context: UIViewControllerContextTransitioning
    ) {
        guard let fromView = context.view(forKey: .from),
              let toView = context.view(forKey: .to) else {
            context.completeTransition(false)
            return
        }
        
        // Set up views
        context.containerView.addSubview(toView)
        context.containerView.addSubview(fromView)
        toView.frame = context.finalFrame(for: toVC)
        
        // Perform the fade animation
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            fromView.alpha = 0.0
        }) { finished in
            fromView.removeFromSuperview()
            context.completeTransition(finished)
        }
    }
}

extension FadeTransitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard 
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) 
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        if operation == .push {
            animatePresent(to: toVC, from: fromVC, using: transitionContext)
        } else if operation == .pop {
            animateDismiss(from: fromVC, to: toVC, using: transitionContext)
        }
    }
}

extension FadeTransitionManager: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation
        return self
    }
}