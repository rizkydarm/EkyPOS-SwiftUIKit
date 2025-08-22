//
//  Extension_UIViewController.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//
import UIKit
import SideMenu

extension UIViewController {

    func setNavigationBarStyle() {
        let standarAppearance = UINavigationBarAppearance()
        standarAppearance.configureWithDefaultBackground()
        standarAppearance.backgroundColor = .systemBrown.withAlphaComponent(0.4)
        standarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        standarAppearance.shadowColor = .clear
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .systemBackground
        scrollEdgeAppearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = standarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance   
        navigationController?.navigationBar.tintColor = .label
    }

    func addMenuButton(mainAppRootNavController: UINavigationController?, menuIndexPage: Int) {
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20, weight: .bold), scale: .large)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                guard let self = self else { return }
                let menuVC = MenuViewController()
                let menuNavContro = SideMenuNavigationController(rootViewController: menuVC)
                menuVC.mainAppRootNavController = mainAppRootNavController
                menuVC.menuActiveIndexPage = menuIndexPage
                menuVC.onDidSelectMenu = { [weak self] row in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                }
                menuNavContro.leftSide = true
                menuNavContro.menuWidth = 300
                menuNavContro.animationOptions = .curveEaseOut
                menuNavContro.presentationStyle = .menuSlideIn
                menuNavContro.edgesForExtendedLayout = .left
                self.present(menuNavContro, animated: true)
            }
        )
        navigationItem.leftBarButtonItem = menuButton
    }

    var isTabletMode: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var isPhoneMode: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    var isCompactMode: Bool {
        traitCollection.horizontalSizeClass == .compact
    }

    var isLandscapeMode: Bool {
        UIDevice.current.orientation.isLandscape
    }

    var isPotrait: Bool {
        UIDevice.current.orientation.isPortrait
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
