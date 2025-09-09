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
        setupSplitViewController()
    }

    public var mainAppRootNavController: UINavigationController?
    public var menuIndexPage: Int = 0

    let _splitViewController = UISplitViewController(style: .doubleColumn)
    
    func setupSplitViewController() {

        mainAppRootNavController = navigationController
    
        let primaryViewController = SalesViewController()
        primaryViewController.mainAppRootNavController = mainAppRootNavController
        let secondaryViewController = CheckoutViewController()
        _splitViewController.viewControllers = [secondaryViewController, primaryViewController]
        
        _splitViewController.primaryEdge = .trailing

        _splitViewController.preferredSplitBehavior = .automatic
        _splitViewController.displayModeButtonVisibility = .never
        _splitViewController.presentsWithGesture = false
        
        addChild(_splitViewController)
        view.addSubview(_splitViewController.view)
        _splitViewController.view.translatesAutoresizingMaskIntoConstraints = false
        _splitViewController.view.frame = view.bounds
        _splitViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        _splitViewController.didMove(toParent: self)
        _splitViewController.delegate = self

        if (isTabletMode && isPotrait) || view.bounds.size.width < 800 {
            _splitViewController.preferredDisplayMode = .secondaryOnly
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true

        setColumn()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        setColumn()
    }

    func setColumn() {
        // print("SplitView width: ", view.bounds.size.width)
        if (isTabletMode && isPotrait) || view.bounds.size.width < 800 {
            _splitViewController.preferredPrimaryColumnWidthFraction = 0
            _splitViewController.minimumPrimaryColumnWidth = 0
            _splitViewController.preferredDisplayMode = .secondaryOnly
        } else {
            _splitViewController.maximumPrimaryColumnWidth = 400
            _splitViewController.minimumPrimaryColumnWidth = 400
            _splitViewController.preferredDisplayMode = .oneBesideSecondary
        }
    }
}

extension SalesCheckoutSplitViewController: UISplitViewControllerDelegate {
//     func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
//         return 
//     }
//     func splitViewController(_ splitViewController: UISplitViewController, separateSecondary secondaryViewController: UIViewController, from primaryViewController: UIViewController) -> Bool {
//         return 
//     }
}
