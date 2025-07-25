//
//  TransactionDetailViewController.swift
//  EkyPOS
//
//  Created by Eky on 25/07/25.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    private let transaction: TransactionModel
        
    init(transaction: TransactionModel) {
        self.transaction = transaction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("Not implemented") }

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Transaction Detail"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TransactionDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let totalPriceLabel = UILabel()
        totalPriceLabel.textColor = .label
        totalPriceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        totalPriceLabel.text = rpCurrencyFormatter.string(from: transaction.totalPrice as NSNumber)
        headerView.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        let totalUnitLabel = UILabel()
        totalUnitLabel.textColor = .label
        totalUnitLabel.font = .systemFont(ofSize: 16, weight: .bold)
        totalUnitLabel.text = "Total unit: \(transaction.products.count)"
        headerView.addSubview(totalUnitLabel)
        totalUnitLabel.snp.makeConstraints { make in
            make.left.equalTo(totalPriceLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaction.products.count     
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .systemBackground
        
        let product = transaction.products[indexPath.row]
        
        let emoji = UILabel()
        emoji.textColor = .label
        emoji.font = .systemFont(ofSize: 24, weight: .bold)
        emoji.text = product.image.containsEmoji ? product.image : "🟤"
        cell.contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = product.name
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(emoji.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}