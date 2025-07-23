//
//  TransactionViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit

class TransactionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transaction"
        view.backgroundColor = .systemBackground
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                self?.sideMenuController?.revealMenu()
            }
        )
        navigationItem.leftBarButtonItem = menuButton
    }
}
