//
//  TransactionViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit

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
        
        addMenuButton(mainAppRootNavController: mainAppRootNavController ?? rootNavigationController, menuIndexPage: menuIndexPage)

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
                showToast(.warning, title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func groupTransactionsByDate() {
        
        let sectionDateFormatter = DateFormatter()
        sectionDateFormatter.dateStyle = .medium
        sectionDateFormatter.timeStyle = .none
        
        let sortingDateFormatter = DateFormatter()
        sortingDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        groupedTransactions = [:]
        sectionTitles = []
        
        for transaction in transactions {
            let dateString = sectionDateFormatter.string(from: transaction.createdAt)
            
            if groupedTransactions[dateString] == nil {
                groupedTransactions[dateString] = [transaction]
                sectionTitles.append(dateString)
            } else {
                groupedTransactions[dateString]?.append(transaction)
            }
        }
        
        sectionTitles.sort { dateString1, dateString2 in
            guard let date1 = sectionDateFormatter.date(from: dateString1),
                let date2 = sectionDateFormatter.date(from: dateString2) else {
                return false
            }
            return date1 > date2
        }
        
        for (key, _) in groupedTransactions {
            groupedTransactions[key]?.sort { transaction1, transaction2 in
                return transaction1.createdAt > transaction2.createdAt
            }
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
        
        let dateString = sectionTitles[indexPath.section]
        let transaction = groupedTransactions[dateString]?[indexPath.row] ?? TransactionModel()
        
        let productsname = transaction.cartProducts.map { $0.product?.name ?? "-" }.joined(separator: ", ")
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
        let dateString = sectionTitles[indexPath.section]
        let transaction = groupedTransactions[dateString]?[indexPath.row] ?? TransactionModel()
        let vc = TransactionDetailViewController(transaction: transaction)
        navigationController?.pushViewController(vc, animated: true)
    }

}
    
    
