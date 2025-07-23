//
//  Untitled.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    private let navigationBar = UINavigationBar(frame: .zero, color: .clear)
    
    private let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Category"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let imageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Image emoji"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    
    var didInputComplete: ((String, String) -> Void)?
    var editingMode: (oldName: String, oldImage: String?)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Category"
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
                if let text = self.inputTextField.text, !text.isEmpty {
                    if let emoji = self.imageTextField.text, !emoji.isEmpty, emoji.count == 1, emoji.containsEmoji {
                        self.didInputComplete?(text, emoji)
                        self.dismiss(animated: true)
                    } else {
                        showToast(.error, vc: self, message: "Text is not emoji")
                    }
                } else {
                    showToast(.error, vc: self, message: "Text is empty")
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
        
        if let editingMode = editingMode {
            inputTextField.text = editingMode.oldName
            if let oldImage = editingMode.oldImage {
                imageTextField.text = oldImage
            } else {
                imageTextField.text = "🟤"
            }
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
