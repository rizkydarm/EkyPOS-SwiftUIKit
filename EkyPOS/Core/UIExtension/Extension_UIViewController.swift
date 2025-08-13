//
//  Extension_UIViewController.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//
import UIKit

extension UIViewController {
    
    func checkMultitaskingState() {
        if self.traitCollection.horizontalSizeClass == .compact {
            // This could be Split View or Slide Over
            if let windowScene = self.view.window?.windowScene {
                let safeAreaInsets = windowScene.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
                if safeAreaInsets.top > 0 && safeAreaInsets.left > 0 {
                    print("Split View mode")
                } else {
                    print("Slide Over mode")
                }
            }
        } else if self.traitCollection.horizontalSizeClass == .regular {
            // This is likely Full Screen or Regular size
            print("Full Screen mode")
        }
    }

    var isTabletMode: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var rootNavigationController: UINavigationController? {
        if let navController = self as? UINavigationController {
            return navController
        }
        
        var current: UIResponder? = self
        while current != nil {
            if let navController = current as? UINavigationController {
                return navController
            }
            current = current?.next
        }
        return self.navigationController
    }
}
