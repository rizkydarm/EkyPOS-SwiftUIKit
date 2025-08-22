import UIKit

class RippleCollectionViewCell: ShrinkCollectionViewCell {
    
    // MARK: - Inspectable Properties
    @IBInspectable var ripplePercent: Float = 0.8 {
        didSet {
            setupRippleView()
        }
    }
    
    @IBInspectable var rippleColor: UIColor = UIColor.systemGray4 {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }

    @IBInspectable var rippleBackgroundColor: UIColor = UIColor.systemGray5 {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    
    @IBInspectable var rippleOverBounds: Bool = false
    @IBInspectable var shadowRippleRadius: Float = 1
    @IBInspectable var shadowRippleEnable: Bool = true
    @IBInspectable var trackTouchLocation: Bool = true
    @IBInspectable var touchUpAnimationTime: Double = 0.6
    
    // MARK: - Private Properties
    private let rippleView = UIView()
    private let rippleBackgroundView = UIView()
    private var tempShadowRadius: CGFloat = 0
    private var tempShadowOpacity: Float = 0
    private var touchCenterLocation: CGPoint?
    
    // MARK: - Computed Properties
    private var rippleMask: CAShapeLayer? {
        get {
            if !rippleOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds,
                    cornerRadius: layer.cornerRadius).cgPath
                return maskLayer
            } else {
                return nil
            }
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup Methods
    private func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.addSubview(rippleView)
        rippleBackgroundView.alpha = 0
        contentView.addSubview(rippleBackgroundView)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
    }
    
    private func setupRippleView() {
        let size: CGFloat = bounds.width * CGFloat(ripplePercent)
        let x: CGFloat = (bounds.width/2) - (size/2)
        let y: CGFloat = (bounds.height/2) - (size/2)
        let corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRect(x: x, y: y, width: size, height: size)
        rippleView.layer.cornerRadius = corner
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if trackTouchLocation, let touch = touches.first {
            touchCenterLocation = touch.location(in: self)
        } else {
            touchCenterLocation = nil
        }
        
        // Animate ripple background
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
        }, completion: nil)
        
        // Scale up ripple view
        rippleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.rippleView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        // Shadow animation
        if shadowRippleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowOpacity = layer.shadowOpacity
            
            let shadowAnim = CABasicAnimation(keyPath: "shadowRadius")
            shadowAnim.toValue = shadowRippleRadius
            
            let opacityAnim = CABasicAnimation(keyPath: "shadowOpacity")
            opacityAnim.toValue = 1
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = .forwards
            groupAnim.isRemovedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            layer.add(groupAnim, forKey: "shadow")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateToNormal()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateToNormal()
    }
    
    // MARK: - Animation Methods
    private func animateToNormal() {
        // Fade out ripple background
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: self.touchUpAnimationTime, delay: 0, options: .allowUserInteraction, animations: {
                self.rippleBackgroundView.alpha = 0
            }, completion: nil)
        }
        
        // Reset ripple view and shadow
        UIView.animate(withDuration: 0.7, delay: 0,
            options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.rippleView.transform = CGAffineTransform.identity
                
                if self.shadowRippleEnable {
                    let shadowAnim = CABasicAnimation(keyPath: "shadowRadius")
                    shadowAnim.toValue = self.tempShadowRadius
                    
                    let opacityAnim = CABasicAnimation(keyPath: "shadowOpacity")
                    opacityAnim.toValue = self.tempShadowOpacity
                    
                    let groupAnim = CAAnimationGroup()
                    groupAnim.duration = 0.7
                    groupAnim.fillMode = .forwards
                    groupAnim.isRemovedOnCompletion = false
                    groupAnim.animations = [shadowAnim, opacityAnim]
                    
                    self.layer.add(groupAnim, forKey: "shadowBack")
                }
            }, completion: nil)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupRippleView()
        if let knownTouchCenterLocation = touchCenterLocation {
            rippleView.center = knownTouchCenterLocation
        }
        
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.layer.mask = rippleMask
    }
}