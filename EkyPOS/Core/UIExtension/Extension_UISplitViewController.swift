
import UIKit

extension UISplitViewController {
    
    // Get the actual width of the primary (master) view
    var primaryViewWidth: CGFloat {
        guard let primaryVC = viewControllers.first else { return 0 }
        return primaryVC.view?.frame.width ?? 0
    }
    
    // Get the actual width of the secondary (detail) view
    var secondaryViewWidth: CGFloat {
        guard let secondaryVC = viewControllers.last else { return 0 }
        return secondaryVC.view?.frame.width ?? 0
    }
    
    // Get the total width of the split view
    var totalSplitViewWidth: CGFloat {
        return view.frame.width
    }
    
    // Get detailed size information
    func getViewSizes() -> [String: CGFloat] {
        return [
            "totalWidth": view.frame.width,
            "primaryWidth": primaryViewWidth,
            "secondaryWidth": secondaryViewWidth,
            "primaryWidthFraction": viewControllers.count > 0 ? (primaryViewWidth / view.frame.width) : 0
        ]
    }
}