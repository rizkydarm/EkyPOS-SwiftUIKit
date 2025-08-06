import UIKit

class SplitViewDelegate: NSObject, UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        print("🎯 WILL CHANGE TO DISPLAY MODE: \(displayModeDescription(displayMode))")
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, didChangeTo displayMode: UISplitViewController.DisplayMode) {
        print("✅ DID CHANGE TO DISPLAY MODE: \(displayModeDescription(displayMode))")
        print("📊 Current screen info: \(screenInfo())")
        print("---")
    }
    
    func splitViewControllerWillChangeDisplayMode(_ svc: UISplitViewController) {
        print("🔄 Split view controller will change display mode")
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        print("➡️ Show detail view controller requested")
        return false // Return false to let default behavior handle it
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
        print("⬅️ Show view controller requested")
        return false // Return false to let default behavior handle it
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        print("🔽 Collapsing secondary view controller onto primary")
        return false // Return false to use default behavior
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        print("🔺 Separating secondary view controller from primary")
        return nil // Return nil to use default behavior
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, primaryViewControllerForCollapsing secondaryViewController: UIViewController) -> UIViewController? {
        print("🔽 Primary view controller for collapsing")
        return nil
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, primaryViewControllerForExpanding secondaryViewController: UIViewController) -> UIViewController? {
        print("🔺 Primary view controller for expanding")
        return nil
    }
    
    // Helper methods for detailed logging
    private func displayModeDescription(_ mode: UISplitViewController.DisplayMode) -> String {
        switch mode {
        case .automatic:
            return "Automatic - System decides layout"
        case .primaryHidden:
            return "Primary Hidden - Secondary view shown, primary accessible via gesture/button"
        case .primaryOverlay:
            return "Primary Overlay - Primary view overlays secondary (iOS 14+)"
        case .secondaryOnly:
            return "Secondary Only - Only detail view visible"
        case .oneBesideSecondary:
            return "One Beside Secondary - Both views side by side"
        case .oneOverSecondary:
            return "One Over Secondary - Primary over secondary (iOS 14+)"
        case .twoBesideSecondary:
            return "Two Beside Secondary - Two primary views beside secondary (iOS 14+)"
        case .twoOverSecondary:
            return "Two Over Secondary - Two primary views over secondary (iOS 14+)"
        case .twoDisplaceSecondary:
            return "Two Displace Secondary - Two primary views displace secondary (iOS 14+)"
        @unknown default:
            return "Unknown mode (\(mode.rawValue))"
        }
    }
    
    private func screenInfo() -> String {
        let screenSize = UIScreen.main.bounds.size
        let orientation = UIDevice.current.orientation
        
        return """
        Size: \(Int(screenSize.width))x\(Int(screenSize.height)) pts
        Orientation: \(orientationDescription(orientation))
        """
    }
    
    private func orientationDescription(_ orientation: UIDeviceOrientation) -> String {
        switch orientation {
        case .portrait:
            return "Portrait"
        case .portraitUpsideDown:
            return "Portrait Upside Down"
        case .landscapeLeft:
            return "Landscape Left"
        case .landscapeRight:
            return "Landscape Right"
        case .faceUp:
            return "Face Up"
        case .faceDown:
            return "Face Down"
        case .unknown:
            return "Unknown"
        @unknown default:
            return "Unknown Orientation"
        }
    }
}