//
//  Untitled.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit

class AddProductViewController: UIViewController {
    
    private lazy var navigationBar = UINavigationBar(frame: .zero, color: .clear)
    
    private lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Product name"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.autocapitalizationType = .sentences
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var imageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Image emoji"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var priceTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Price"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private lazy var costTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Cost"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private lazy var barcodeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Barcode"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private lazy var descTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Description"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private lazy var stockTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Stock"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var didInputComplete: ((ProductModel) -> Void)?
    var editingMode: ProductModel?
    
    private lazy var currencyTextFieldDelegate = CurrencyTextFieldDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Product"
        view.backgroundColor = .systemBackground
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        navigationBar.scrollEdgeAppearance?.backgroundColor = .clear
        navigationBar.standardAppearance.backgroundColor = .clear
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        let checkButton = UIBarButtonItem(
            image: UIImage(systemName: "checkmark")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                guard let self = self else { return }
                
                guard let name = self.inputTextField.text, !name.isEmpty else {
                    showToast(.warning, title: "Error", message: "Name is empty")
                    return
                }

                guard let emoji = self.imageTextField.text, !emoji.isEmpty, emoji.count == 1, emoji.containsEmoji else {
                    showToast(.warning, title: "Error", message: "Image is not emoji or image is empty")
                    return
                }

                guard let desc = self.descTextField.text, !desc.isEmpty else {
                    showToast(.warning, title: "Error", message: "Description is empty")
                    return
                }

                let priceVal = currencyTextFieldDelegate.getRawValue(for: priceTextField)
                if priceVal.isZero {
                    showToast(.warning, title: "Error", message: "Price is empty")
                    return
                }

                let costVal = currencyTextFieldDelegate.getRawValue(for: costTextField)
                if costVal.isZero {
                    showToast(.warning, title: "Error", message: "Cost is empty")
                    return
                }

                guard let stock = self.stockTextField.text, !stock.isEmpty, let stockInt = Int(stock) else {
                    showToast(.warning, title: "Error", message: "Stock is empty")
                    return
                }

                guard let barcode = self.barcodeTextField.text, !barcode.isEmpty else {
                    showToast(.warning, title: "Error", message: "Barcode is empty")
                    return
                }

                let product = ProductModel()
                product.name = name
                product.image = emoji
                product.price = priceVal
                product.cost = costVal
                product.barcode = barcode
                product.desc = desc
                product.stock = stockInt
                self.didInputComplete?(product)
                self.dismiss(animated: true)
            }
        )
        navigationItem.rightBarButtonItem = checkButton
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        navigationBar.setItems([navigationItem], animated: true)
        
        view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        view.addSubview(imageTextField)
        imageTextField.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        view.addSubview(priceTextField)
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(imageTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        priceTextField.delegate = currencyTextFieldDelegate

        view.addSubview(costTextField)
        costTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        costTextField.delegate = currencyTextFieldDelegate

        view.addSubview(barcodeTextField)
        barcodeTextField.snp.makeConstraints { make in
            make.top.equalTo(costTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        let generateButton = UIButton(type: .system)
        generateButton.setTitle("Generate", for: .normal)
        generateButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        generateButton.addTarget(self, action: #selector(generateUUID), for: .touchUpInside)
        
        generateButton.sizeToFit()
        
        barcodeTextField.rightView = generateButton
        barcodeTextField.rightViewMode = .always

        view.addSubview(stockTextField)
        stockTextField.snp.makeConstraints { make in
            make.top.equalTo(barcodeTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        view.addSubview(descTextField)
        descTextField.snp.makeConstraints { make in
            make.top.equalTo(stockTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        if let editingMode = editingMode {
            inputTextField.text = editingMode.name
            imageTextField.text = editingMode.image
            descTextField.text = editingMode.desc
            priceTextField.text = editingMode.price.formatted()
            costTextField.text = editingMode.cost.formatted()
            barcodeTextField.text = editingMode.barcode
            stockTextField.text = String(editingMode.stock)
        }
    }

    @objc private func generateUUID() {
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let truncatedUUID = String(uuid.prefix(16))
        barcodeTextField.text = truncatedUUID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = navigationBar.standardAppearance.copy()
        appearance.backgroundColor = .clear
        navigationBar.standardAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.standardAppearance = UINavigationBar.appearance().standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
    }
}
