//
//  MainSplitViewController.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//

import UIKit

class MainSplitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplitViewController()
    }

    private lazy var splitViewDelegate = SplitViewDelegate()
    
    let primaryViewController = SalesViewController()
    let secondaryViewController = CheckoutViewController()
    
    func setupSplitViewController() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        
        let masterNavigationController = UINavigationController(rootViewController: primaryViewController)
        let detailNavigationController = UINavigationController(rootViewController: secondaryViewController)
        
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        
//        splitViewController.preferredDisplayMode = .automatic
//        splitViewController.maximumPrimaryColumnWidth = 1200
//        splitViewController.minimumPrimaryColumnWidth = 600
//        splitViewController.preferredPrimaryColumnWidthFraction = 0.3
        
        addChild(splitViewController)
        view.addSubview(splitViewController.view)
        splitViewController.view.frame = view.bounds
        splitViewController.didMove(toParent: self)
        splitViewController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        print("separateSecondaryFrom primaryViewController")
        return nil
    }
    func splitViewController(_ splitViewController: UISplitViewController, primaryViewControllerForCollapsing secondaryViewController: UIViewController) -> UIViewController? {
        print("primaryViewControllerForCollapsing secondaryViewController")
        return nil
    }
    func splitViewController(_ splitViewController: UISplitViewController, primaryViewControllerForExpanding secondaryViewController: UIViewController) -> UIViewController? {
        print("primaryViewControllerForExpanding secondaryViewController")
        return nil
    }
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        print("willChangeTo: \(displayModeDescription(displayMode))")
    }
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

}
