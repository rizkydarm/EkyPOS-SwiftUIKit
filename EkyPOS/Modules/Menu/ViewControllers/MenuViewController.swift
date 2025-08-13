//
//  MenuSideViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import SnapKit
import SideMenu

class MenuViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()

    var mainAppRootNavController: UINavigationController?

    var onDidSelectMenu: ((Int) -> Void)?

    var menuActiveIndexPage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu"
        view.backgroundColor = .systemBackground
        view.tintColor = .label

        navigationController?.isNavigationBarHidden = true
        navigationController?.view.setBorder(color: .systemGreen, width: 5)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
//        UINavigationBar.appearance().tintColor = .label
//        
//        let standarAppearance = UINavigationBarAppearance()
//        standarAppearance.configureWithDefaultBackground()
//        standarAppearance.backgroundColor = .systemBrown.withAlphaComponent(0.4)
//        standarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//        standarAppearance.shadowColor = .clear
//        
//        let scrollEdgeAppearance = UINavigationBarAppearance()
//        scrollEdgeAppearance.backgroundColor = .systemBackground
//        scrollEdgeAppearance.shadowColor = .clear
//
//        salesNavContro.navigationBar.standardAppearance = standarAppearance
//        salesNavContro.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
//        
//        salesNavContro.navigationBar.tintColor = .label
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground

        let imageLogo = UIImageView()
        imageLogo.image = UIImage(named: "LaunchIcon")
        view.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }

        return view
    }
    
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

        switch row {
            case 0:
            if menuActiveIndexPage != 0 {
                if isTabletMode {
                    let salesCheckoutSplitVC = SalesCheckoutSplitViewController()
                    salesCheckoutSplitVC.mainAppRootNavController = mainAppRootNavController
                    mainAppRootNavController?.setViewControllers([salesCheckoutSplitVC], animated: true)
                } else {
                    mainAppRootNavController?.setNavigationBarHidden(false, animated: true)
                    mainAppRootNavController?.setViewControllers([SalesViewController()], animated: true)
                }
            }
            case 1:
            if menuActiveIndexPage != 1 {
                let categoryVC = CategoryViewController()
                mainAppRootNavController?.setNavigationBarHidden(false, animated: true)
                mainAppRootNavController?.setViewControllers([categoryVC], animated: true)
            }
            case 2:
            if menuActiveIndexPage != 2 {
                let transactionVC = TransactionViewController()
                mainAppRootNavController?.setNavigationBarHidden(false, animated: true)
                mainAppRootNavController?.setViewControllers([transactionVC], animated: true)
            }
            default:
            break
        }

        onDidSelectMenu?(row)
    }
}
