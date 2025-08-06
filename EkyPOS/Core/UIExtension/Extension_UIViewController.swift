//
//  Extension_UIViewController.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//
import UIKit

extension UIViewController {
    
    var isInSplitView: Bool {
        guard let splitVC = self.splitViewController else {
            return false
        }
        
        return splitVC.displayMode != .secondaryOnly &&
               splitVC.viewControllers.count > 1
    }
    
    var isPrimaryVisible: Bool {
        guard let splitVC = self.splitViewController else {
            return false
        }
        
        return splitVC.displayMode != .secondaryOnly
    }
    
}
