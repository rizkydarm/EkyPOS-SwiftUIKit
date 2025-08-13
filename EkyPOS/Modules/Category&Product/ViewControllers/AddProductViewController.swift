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

    private lazy var descTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Description"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var didInputComplete: ((String, String, Double, String) -> Void)?
    var editingMode: (oldName: String, oldImage: String, oldPrice: Double, oldDesc: String)?
    
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
                
                let priceVal = currencyTextFieldDelegate.getRawValue(for: priceTextField)

                if let name = self.inputTextField.text, !name.isEmpty {
                    if let emoji = self.imageTextField.text, !emoji.isEmpty, emoji.count == 1, emoji.containsEmoji {
                        if !priceVal.isZero {
                            if let desc = self.descTextField.text, !desc.isEmpty {
                                self.didInputComplete?(name, emoji, priceVal, desc)
                                self.dismiss(animated: true)
                            } else {
                                showBanner(.warning, title: "Error", message: "Description is empty")
                            }
                        } else {
                            showBanner(.warning, title: "Error", message: "Price is empty")
                        }
                    } else {
                        showBanner(.warning, title: "Error", message: "Image is not emoji")
                    }
                } else {
                    showBanner(.warning, title: "Error", message: "Name is empty")
                }
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

        view.addSubview(descTextField)
        descTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        if let editingMode = editingMode {
            inputTextField.text = editingMode.oldName
            imageTextField.text = editingMode.oldImage
            descTextField.text = editingMode.oldDesc
            priceTextField.text = editingMode.oldPrice.formatted()
        }
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
