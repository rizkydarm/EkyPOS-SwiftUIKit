//
//  PaymentViewController.swift
//  EkyPOS
//
//  Created by Eky on 24/07/25.
//

import UIKit
import SnapKit

class PaymentViewController: UIViewController {

    var checkoutModel: CheckoutModel?

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Cash", at: 0, animated: true)
        control.insertSegment(withTitle: "QRIS", at: 1, animated: true)
        control.selectedSegmentIndex = 0
        control.tintColor = .systemBrown
        return control
    }()

    private let currencyTextFieldDelegate = CurrencyTextFieldDelegate()
    private let nominalTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Rp 0"
        tf.keyboardType = .numberPad
        tf.textColor = .label
        tf.backgroundColor = .secondarySystemFill
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return tf
    }()
    private var nominalValue: Double = 0

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBrown
        button.tintColor = .label
        button.layer.cornerRadius = 8
        button.enableBounceAnimation()
        return button
    }()

    private let switchNominal: UISwitch = {
        let control = UISwitch()
        control.onTintColor = .systemBrown
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Payment"
        view.backgroundColor = .systemBackground

        let totalPriceLabel = UILabel()
        totalPriceLabel.textColor = .secondaryLabel
        totalPriceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        totalPriceLabel.text = "Total price"

        view.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.centerX.equalToSuperview()
        }
        if let totalPrice = checkoutModel?.totalPrice {
            amountLabel.text = rpCurrencyFormatter.string(from: totalPrice as NSNumber) ?? "-"
        } else {
            amountLabel.text = "-"
        }
        
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }

        let nominalLabel = UILabel()
        nominalLabel.textColor = .secondaryLabel
        nominalLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nominalLabel.text = "Nominal"
        nominalLabel.textAlignment = .left

        view.addSubview(nominalLabel)
        nominalLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }

        nominalTextField.delegate = currencyTextFieldDelegate
        view.addSubview(nominalTextField)
        nominalTextField.snp.makeConstraints { make in
            make.top.equalTo(nominalLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        view.addSubview(switchNominal)
        switchNominal.snp.makeConstraints { make in
            make.top.equalTo(nominalTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }

        let switchLabel = UILabel()
        switchLabel.textColor = .secondaryLabel
        switchLabel.font = .systemFont(ofSize: 16, weight: .bold)
        switchLabel.text = "Auto nominal"
        switchLabel.textAlignment = .left

        view.addSubview(switchLabel)
        switchLabel.snp.makeConstraints { make in
            make.left.equalTo(switchNominal.snp.right).offset(20)
            make.centerY.equalTo(switchNominal)
        }

        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(switchNominal.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }

        actionButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.switchNominal.isOn == true {
                let invoiceVC = InvoiceViewController()
                if let checkoutModel = self.checkoutModel {
                    invoiceVC.invoiceModel = InvoiceModel(checkout: checkoutModel)
                }
                self.navigationController?.pushViewController(invoiceVC, animated: true)
            } else {
                let totalPrice = self.checkoutModel?.totalPrice ?? 0
                self.nominalValue = currencyTextFieldDelegate.getRawValue(for: self.nominalTextField)
                if self.nominalValue < totalPrice {
                    showToast(.error, vc: self, message: "Nominal is less than total price", seconds: 1)
                } else {
                    let invoiceVC = InvoiceViewController()
                    if let checkoutModel = self.checkoutModel {
                        let changes = self.nominalValue - totalPrice
                        invoiceVC.invoiceModel = InvoiceModel(checkout: checkoutModel, changes: changes)
                    }
                    self.navigationController?.pushViewController(invoiceVC, animated: true)
                }
            }
        }, for: .touchUpInside)

        switchNominal.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.switchNominal.isOn == true {
                if let totalPrice = self.checkoutModel?.totalPrice {
                    self.nominalTextField.text = rpCurrencyFormatter.string(from: totalPrice as NSNumber)
                }
                self.nominalValue = 0
                self.nominalTextField.isEnabled = false
            } else {
                self.nominalTextField.text = ""
                self.nominalValue = 0
                self.nominalTextField.isEnabled = true
            }
        }, for: .valueChanged) 
    }
}
