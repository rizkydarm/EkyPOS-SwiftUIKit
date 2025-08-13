//
//  TransactionViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import SideMenu

class TransactionViewController: UIViewController {

    private let transactionRepo = TransactionRepo()
    private var transactions: [TransactionModel] = []

    private var groupedTransactions: [String: [TransactionModel]] = [:]
    private var sectionTitles: [String] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No transaction"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var mainAppRootNavController: UINavigationController?
    public var menuIndexPage: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transaction"
        view.backgroundColor = .systemBackground
        
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20, weight: .bold), scale: .large)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                guard let self = self else { return }
                let menuVC: MenuViewController = MenuViewController()
                menuVC.mainAppRootNavController = self.rootNavigationController
                menuVC.onDidSelectMenu = { [weak self] row in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                }
                menuVC.menuActiveIndexPage = self.menuIndexPage
                let menuNavContro = SideMenuNavigationController(rootViewController: menuVC)
                menuNavContro.leftSide = true
                menuNavContro.menuWidth = 300
                menuNavContro.animationOptions = .curveEaseOut
                menuNavContro.presentationStyle = .menuSlideIn
                menuNavContro.edgesForExtendedLayout = .left
                self.present(menuNavContro, animated: true)
            }
        )
        navigationItem.leftBarButtonItem = menuButton

        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        loadAllTransactions()
        groupTransactionsByDate()
    }

    private func loadAllTransactions() {
        transactionRepo.getAllTransactions { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transactions):
                self.transactions = transactions
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !self.transactions.isEmpty
            case .failure(let error):
                showBanner(.warning, title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func groupTransactionsByDate() {
        // Create a date formatter for the section titles
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Reset our data structures
        groupedTransactions = [:]
        sectionTitles = []
        
        // Group transactions by date string
        for transaction in transactions {
            let dateString = dateFormatter.string(from: transaction.createdAt)
            
            if groupedTransactions[dateString] == nil {
                groupedTransactions[dateString] = [transaction]
                sectionTitles.append(dateString)
            } else {
                groupedTransactions[dateString]?.append(transaction)
            }
        }
        
        // Sort sections by date (newest first)
        sectionTitles.sort { (dateString1, dateString2) -> Bool in
            guard let date1 = dateFormatter.date(from: dateString1),
                  let date2 = dateFormatter.date(from: dateString2) else {
                return false
            }
            return date1 > date2
        }
        
        for (key, _) in groupedTransactions {
            groupedTransactions[key]?.sort { $0.createdAt > $1.createdAt }
        }
        
        tableView.reloadData()
    }

}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateString = sectionTitles[section]
        return groupedTransactions[dateString]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .systemBackground
        
        let transaction = transactions[indexPath.row]
        
        let productsname = transaction.products.map { $0.name }.joined(separator: ", ")
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = productsname
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().multipliedBy(0.8)
        }
        let priceLabel = UILabel()
        priceLabel.textColor = .secondaryLabel
        priceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        priceLabel.text = rpCurrencyFormatter.string(from: transaction.totalPrice as NSNumber)
        cell.contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(label.snp.left)
            make.top.equalTo(label.snp.bottom).offset(4)
        }

        let timeLabel = UILabel()
        timeLabel.textColor = .secondaryLabel
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.text = transaction.createdAt.formattedTimeOnly()
        cell.contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.textColor = .darkGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = transactions[indexPath.row]
        let vc = TransactionDetailViewController(transaction: transaction)
        navigationController?.pushViewController(vc, animated: true)
    }

}
    
    
