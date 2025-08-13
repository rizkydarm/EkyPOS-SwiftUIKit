//
//  InvoiceViewController.swift
//  EkyPOS
//
//  Created by Eky on 24/07/25.
//

import UIKit
import RealmSwift

class InvoiceViewController: UIViewController {

    var invoiceModel: InvoiceModel?

    private let transactionRepo = TransactionRepo()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()

    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()

    private let printButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Print", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGray
        button.tintColor = .label
        button.layer.cornerRadius = 8
        let icon = UIImage(systemName: "printer.fill")
        button.setImage(icon, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 16
        button.configuration = configuration
        button.enableBounceAnimation()
        return button
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBrown
        button.tintColor = .label
        button.layer.cornerRadius = 8
        button.enableBounceAnimation()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Invoice"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        bottomBar.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bottomBar.safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        bottomBar.addSubview(printButton)
        printButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(doneButton.snp.top).offset(-20)
            make.top.equalTo(bottomBar.snp.top).offset(20)
        }

        printButton.addAction(UIAction { _ in
            
        }, for: .touchUpInside)

        doneButton.addAction(UIAction { [weak self] _ in
            guard let invoiceModel = self?.invoiceModel else { return }
            let productList = List<ProductModel>()
            productList.append(objectsIn: invoiceModel.checkout.cartProducts.map { $0.product })
            self?.transactionRepo.addTransaction(
                totalPrice: invoiceModel.checkout.totalPrice,
                totalUnit: invoiceModel.checkout.totalUnit, 
                changes: invoiceModel.changes, 
                paymentMethod: invoiceModel.paymentMethod,
                products: productList
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.navigationController?.setViewControllers([SalesViewController()], animated: true)
                case .failure(let error):
                    showBanner(.warning, title: "Error", message: error.localizedDescription)
                }
            }
        }, for: .touchUpInside)
    }
}

extension InvoiceViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground

        let verticalDivider = UIView()
        verticalDivider.backgroundColor = .systemGray
        view.addSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).inset(20)
            make.width.equalTo(1)
        }

        let totalPaymentLabel = UILabel()
        totalPaymentLabel.textColor = .secondaryLabel
        totalPaymentLabel.font = .systemFont(ofSize: 20, weight: .bold)
        totalPaymentLabel.text = "Total Payment"
        let spacer1 = UIView()
        view.addSubview(spacer1)
        spacer1.snp.makeConstraints { make in
            make.right.equalTo(verticalDivider.snp.left)
            make.left.equalTo(view.snp.left)
            make.height.equalTo(0)
        }
        view.addSubview(totalPaymentLabel)
        totalPaymentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalTo(spacer1)
        }

        let changeLabel = UILabel()
        changeLabel.textColor = .secondaryLabel
        changeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        changeLabel.text = "Change"
        let spacer2 = UIView()
        view.addSubview(spacer2)
        spacer2.snp.makeConstraints { make in
            make.left.equalTo(verticalDivider.snp.right)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(0)
        }
        view.addSubview(changeLabel)
        changeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalTo(spacer2)
        }

        let totalPaymentValueLabel = UILabel()
        totalPaymentValueLabel.textColor = .label
        totalPaymentValueLabel.font = .systemFont(ofSize: 24, weight: .bold)
        totalPaymentValueLabel.text = invoiceModel?.checkout.totalPrice != nil ? rpCurrencyFormatter.string(from: invoiceModel!.checkout.totalPrice as NSNumber) : "-"
        view.addSubview(totalPaymentValueLabel)
        totalPaymentValueLabel.snp.makeConstraints { make in
            make.top.equalTo(totalPaymentLabel.snp.bottom).offset(20)
            make.centerX.equalTo(spacer1)
        }

        let changeValueLabel = UILabel()
        changeValueLabel.textColor = .label
        changeValueLabel.font = .systemFont(ofSize: 24, weight: .bold)
        changeValueLabel.text = invoiceModel?.changes != nil ? rpCurrencyFormatter.string(from: invoiceModel!.changes as NSNumber) : "-"
        view.addSubview(changeValueLabel)
        changeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(changeLabel.snp.bottom).offset(20)
            make.centerX.equalTo(spacer2)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceModel?.checkout.cartProducts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let product = invoiceModel?.checkout.cartProducts[indexPath.row].product

        let emoji = UILabel()
        emoji.textColor = .label
        emoji.font = .systemFont(ofSize: 24, weight: .bold)
        emoji.text = product?.image.containsEmoji ?? false ? product?.image : "🟤"
        cell.contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = product?.name ?? "-"
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(emoji.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        let subLabel = UILabel()
        subLabel.textColor = .secondaryLabel
        subLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subLabel.text = product?.price != nil ? rpCurrencyFormatter.string(from: product!.price as NSNumber) : "-"
        cell.contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        let quantityLabel = UILabel()
        quantityLabel.textColor = .label
        quantityLabel.font = .systemFont(ofSize: 16, weight: .bold)
        quantityLabel.text = "x " + String(invoiceModel?.checkout.cartProducts[indexPath.row].total ?? 0)
        cell.contentView.addSubview(quantityLabel)
        quantityLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        return cell
    }
    
}
