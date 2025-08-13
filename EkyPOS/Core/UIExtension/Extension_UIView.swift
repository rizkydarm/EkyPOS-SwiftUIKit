//
//  Extension_UIView.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit

extension UIView {
    
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        backgroundColor = color
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { subView in
            self.addSubview(subView)
        }
    }
    
    func setCornerRadius(_ radius: CGFloat, maskedCorner: CACornerMask? = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorner ?? [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        clipsToBounds = true
    }
    
    func setCornerRadiusRounded() {
        let heigth = self.frame.height
        layer.cornerRadius = heigth/2
        clipsToBounds = true
    }

    // Computed property for adding a colored border
    func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    // Convenience method to remove the border
    func removeBorder() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
    }

}
