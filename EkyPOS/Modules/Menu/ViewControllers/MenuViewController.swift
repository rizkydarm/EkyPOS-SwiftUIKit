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

    public var mainAppRootNavController: UINavigationController?

    public var onDidSelectMenu: ((Int) -> Void)?

    public var menuActiveIndexPage: Int?

    private var transitionManager: FadeTransitionManager?

    func setViewControllersWithFade(_ viewControllers: [UIViewController]) {
        guard let mainAppRootNavController = mainAppRootNavController ?? rootNavigationController else { return }
        
        transitionManager = FadeTransitionManager(duration: 0.3)
        mainAppRootNavController.delegate = transitionManager
        
        mainAppRootNavController.setViewControllers(viewControllers, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mainAppRootNavController?.delegate = nil
            self.transitionManager = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu"
        view.backgroundColor = .systemBackground
        view.tintColor = .label

        navigationController?.isNavigationBarHidden = true
        // navigationController?.view.setBorder(color: .systemGreen, width: 5)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
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
                    let salesVC: SalesViewController = SalesViewController()
                    salesVC.mainAppRootNavController = mainAppRootNavController
                    setViewControllersWithFade([salesVC])
                    mainAppRootNavController?.setNavigationBarHidden(false, animated: true)
                    // mainAppRootNavController?.navigationBar.prefersLargeTitles = true
                }
            }
            case 1:
            if menuActiveIndexPage != 1 {
                let categoryVC: CategoryViewController = CategoryViewController()
                categoryVC.mainAppRootNavController = mainAppRootNavController
                mainAppRootNavController?.setViewControllers([categoryVC], animated: true)
                mainAppRootNavController?.setNavigationBarHidden(false, animated: true)
                // mainAppRootNavController?.navigationBar.prefersLargeTitles = true
                // navigationItem.largeTitleDisplayMode = .always
            }
            case 2:
            if menuActiveIndexPage != 2 {
                let transactionVC: TransactionViewController = TransactionViewController()
                transactionVC.mainAppRootNavController = mainAppRootNavController
                mainAppRootNavController?.setViewControllers([transactionVC], animated: true)
                mainAppRootNavController?.setNavigationBarHidden(false, animated: true)
                // mainAppRootNavController?.navigationBar.prefersLargeTitles = false
            }
            default:
            break
        }

        onDidSelectMenu?(row)
    }
}
