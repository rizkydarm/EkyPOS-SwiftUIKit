//
//  MainSplitViewController.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//

import UIKit

class SalesCheckoutSplitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplitViewController()
    }
    
    let primaryViewController = SalesViewController()
    let secondaryViewController = CheckoutViewController()
    let menuViewController = MenuViewController()
    
    func setupSplitViewController() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        
        let primaryNavigationController = UINavigationController(rootViewController: primaryViewController)
        let secondaryNavigationController = UINavigationController(rootViewController: secondaryViewController)
        
        let splitViewController = UISplitViewController()
        
//        splitViewController.setViewController(primaryNavigationController, for: .compact)
//        splitViewController.setViewController(primaryNavigationController, for: .primary)
//        splitViewController.setViewController(secondaryNavigationController, for: .secondary)
        splitViewController.viewControllers = [primaryNavigationController, secondaryNavigationController]
//        splitViewController.preferredSplitBehavior = .tile
        splitViewController.preferredDisplayMode = .automatic
//        splitViewController.presentsWithGesture = true
        
        addChild(splitViewController)
        view.addSubview(splitViewController.view)
        splitViewController.view.frame = view.bounds
        splitViewController.didMove(toParent: self)
        splitViewController.delegate = self
    }

}

extension SalesCheckoutSplitViewController: UISplitViewControllerDelegate {
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
//        return true
//    }
//    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
//        // When collapsing, show the secondary view controller (on left)
//        return .primary
//    }
//    func splitViewController(_ splitViewController: UISplitViewController, displayModeForExpandingFromDisplayMode displayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
//        // When expanding, show both columns with custom arrangement
//        return .twoBesideSecondary
//    }
//    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
//        return false
//    }
//    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
//        print("separateSecondaryFrom primaryViewController")
//        return nil
//    }
//    func splitViewController(_ splitViewController: UISplitViewController, primaryViewControllerForCollapsing secondaryViewController: UIViewController) -> UIViewController? {
//        print("primaryViewControllerForCollapsing secondaryViewController")
//        return nil
//    }
//    func splitViewController(_ splitViewController: UISplitViewController, primaryViewControllerForExpanding secondaryViewController: UIViewController) -> UIViewController? {
//        print("primaryViewControllerForExpanding secondaryViewController")
//        return nil
//    }
//    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
//        print("willChangeTo: \(displayModeDescription(displayMode))")
//    }
//    private func displayModeDescription(_ mode: UISplitViewController.DisplayMode) -> String {
//        switch mode {
//        case .automatic:
//            return "Automatic - System decides layout"
//        case .primaryHidden:
//            return "Primary Hidden - Secondary view shown, primary accessible via gesture/button"
//        case .primaryOverlay:
//            return "Primary Overlay - Primary view overlays secondary (iOS 14+)"
//        case .secondaryOnly:
//            return "Secondary Only - Only detail view visible"
//        case .oneBesideSecondary:
//            return "One Beside Secondary - Both views side by side"
//        case .oneOverSecondary:
//            return "One Over Secondary - Primary over secondary (iOS 14+)"
//        case .twoBesideSecondary:
//            return "Two Beside Secondary - Two primary views beside secondary (iOS 14+)"
//        case .twoOverSecondary:
//            return "Two Over Secondary - Two primary views over secondary (iOS 14+)"
//        case .twoDisplaceSecondary:
//            return "Two Displace Secondary - Two primary views displace secondary (iOS 14+)"
//        @unknown default:
//            return "Unknown mode (\(mode.rawValue))"
//        }
//    }

}
