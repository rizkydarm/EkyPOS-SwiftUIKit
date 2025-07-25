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
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No transaction"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        transactions = transactionRepo.getAllTransactions()
        tableView.reloadData()
        emptyLabel.isHidden = !transactions.isEmpty
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
        
        // Sort transactions within each section (newest first)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let dateString = sectionTitles[indexPath.section]
        if let transaction = groupedTransactions[dateString]?[indexPath.row] {
            // Configure your cell with transaction data
            // Example:
            cell.textLabel?.text = "\(transaction.totalPrice)"
            
            // If you want to show time for individual transactions
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            cell.detailTextLabel?.text = timeFormatter.string(from: transaction.createdAt)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.textColor = .darkGray
    }
    
    // Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle transaction selection
    }

}
    
    