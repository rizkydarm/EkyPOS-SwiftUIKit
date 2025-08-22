//
//  CategoryProductViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit


class ProductViewController: UIViewController {
    
    private let category: CategoryModel
        
    init(category: CategoryModel) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("Not implemented") }
    
    private let productRepo = ProductRepo()
    private var products: [ProductModel] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No product"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var mainAppRootNavController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(category.name) Product"
        view.backgroundColor = .systemBackground
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                let vc = AddProductViewController()
                vc.didInputComplete = { [weak self] (name, image, price, desc) in
                    guard let self = self else { return }
                    self.productRepo.addProduct(name: name, description: desc, price: price, image: image, category: category) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success():
                            self.loadProducts()
                        case .failure(let error):
                            showToast(.warning, title: "Error", message: error.localizedDescription)
                        }
                    }
                }
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true)
            }
        )
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = .systemBrown
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AddedProductCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadProducts()
    }
    
    private func loadProducts() {
        productRepo.getProducts(byCategory: category) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !self.products.isEmpty
            case .failure(let error):
                showToast(.warning, title: "Error", message: error.localizedDescription)
            }
        }
    }

}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddedProductCell
        
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                    
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let product = products[indexPath.row]
            self.productRepo.deleteProduct(id: product._id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    completion(true)
                    products.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.loadProducts()
                case .failure(let error):
                    completion(false)
                    showToast(.warning, title: "Error", message: error.localizedDescription)
                }
            }
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let vc = AddProductViewController()
            let selectedProduct = products[indexPath.row]
            vc.editingMode = (selectedProduct.name, selectedProduct.image, selectedProduct.price, selectedProduct.desc)
            vc.didInputComplete = { [weak self] (text, image, price, desc) in
                guard let self = self else { return }
                let product = products[indexPath.row]
                productRepo.updateProduct(id: product._id, newName: text, newDesc: desc, newPrice: price, newImage: image) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success():
                        completion(true)
                        self.loadProducts()
                    case .failure(let error):
                        completion(false)
                        showToast(.warning, title: "Error", message: error.localizedDescription)
                    }
                }
            }
            self.present(vc, animated: true)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
