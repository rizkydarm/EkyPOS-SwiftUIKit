//
//  MenuSideViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import SnapKit
import SideMenuSwift

class MenuViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu"
        view.backgroundColor = .systemBackground
        view.tintColor = .label
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        UINavigationBar.appearance().tintColor = .label
        
        let salesNavContro = UINavigationController(rootViewController: SalesViewController())
        let categoryproductNavContro = UINavigationController(rootViewController: CategoryViewController())
        let transactionNavContro = UINavigationController(rootViewController: TransactionViewController())
        
        let standarAppearance = UINavigationBarAppearance()
        standarAppearance.configureWithDefaultBackground()
        standarAppearance.backgroundColor = .systemBrown.withAlphaComponent(0.4)
        standarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        standarAppearance.shadowColor = .clear
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .systemBackground
        scrollEdgeAppearance.shadowColor = .clear

        salesNavContro.navigationBar.standardAppearance = standarAppearance
        salesNavContro.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        
        salesNavContro.navigationBar.tintColor = .label
        salesNavContro.navigationBar.isTranslucent = true
        
        sideMenuController?.cache(viewController: salesNavContro, with: "0")
        sideMenuController?.cache(viewController: categoryproductNavContro, with: "1")
        sideMenuController?.cache(viewController: transactionNavContro, with: "2")
        
        sideMenuController?.delegate = self
    }
    
    private func configureGlobalNavigationBarAppearance() {
        
    }
    
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuControllerGetMenuWidth(_ sideMenuController: SideMenuController, for size: CGSize) -> CGFloat? {
        300
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        switch indexPath.row {
            case 0:
            label.text = "Sales"
            case 1:
            label.text = "Category & Product"
            default:
            label.text = "Transactions"
        }
        
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        sideMenuController?.setContentViewController(with: "\(row)", animated: true)
        sideMenuController?.hideMenu()
    }
}
