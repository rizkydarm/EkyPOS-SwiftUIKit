//
//  MainSplitViewController.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//

import UIKit
import SideMenu

class SalesCheckoutSplitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rootNavigationController?.view.setBorder(color: .systemOrange, width: 8)

        setupSplitViewController()
    }

    public var mainAppRootNavController: UINavigationController?
    
    public var menuIndexPage: Int = 0
    
    func setupSplitViewController() {

        mainAppRootNavController = navigationController
        
        let splitViewController = UISplitViewController(style: .doubleColumn)
        
        let primaryViewController = SalesViewController()
        primaryViewController.mainAppRootNavController = mainAppRootNavController
        let secondaryViewController = CheckoutViewController()
        splitViewController.viewControllers = [secondaryViewController, primaryViewController]
        
        splitViewController.primaryEdge = .trailing

        splitViewController.preferredDisplayMode = .oneBesideSecondary
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
}

extension SalesCheckoutSplitViewController: UISplitViewControllerDelegate {
   func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
       return false
   }
}
