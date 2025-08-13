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
    
    private let primaryViewController = SalesViewController()
    private let secondaryViewController = CheckoutViewController()
//    let menuViewController = MenuViewController()
    
    func setupSplitViewController() {
        
        // let primaryNavigationController: UINavigationController = UINavigationController(rootViewController: primaryViewController)
        // let secondaryNavigationController = UINavigationController(rootViewController: secondaryViewController)

        let splitViewController = UISplitViewController(style: .doubleColumn)
        
        splitViewController.viewControllers = [secondaryViewController, primaryViewController]
        
        splitViewController.primaryEdge = .trailing

        splitViewController.preferredDisplayMode = .automatic
        splitViewController.preferredSplitBehavior = .automatic
        splitViewController.displayModeButtonVisibility = .never
        splitViewController.presentsWithGesture = false

        splitViewController.preferredPrimaryColumnWidthFraction = 0.5
        
        addChild(splitViewController)
        view.addSubview(splitViewController.view)
        splitViewController.view.translatesAutoresizingMaskIntoConstraints = false
        splitViewController.view.frame = view.bounds
        splitViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        splitViewController.didMove(toParent: self)
        splitViewController.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true        
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Check multitasking state when the trait collection changes
        checkMultitaskingState()
    }

}

extension SalesCheckoutSplitViewController: UISplitViewControllerDelegate {
   func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
       return false
   }
   func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        switch displayMode {
        case .automatic:
            print("Automatic display mode")
        case .primaryHidden:
            print("Primary view hidden (Slide Over)")
        case .allVisible:
            print("Both views visible (Split View)")
        case .primaryOverlay:
            print("Primary view overlay")
        default:
            print("Unknown display mode")
        }
    }
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
