//
//  Extension_UISegmentedControl.swift
//  EkyPOS
//
//  Created by Eky on 24/07/25.
//

import UIKit

extension UISegmentedControl {
    
    func removeBorders() {
        setBackgroundImage(imageWithColor(UIColor.white), for: UIControl.State(), barMetrics: .default)
        setBackgroundImage(imageWithColor(tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(UIColor.clear), forLeftSegmentState: UIControl.State(), rightSegmentState: UIControl.State(), barMetrics: .default)
    }
    
    fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }

}
