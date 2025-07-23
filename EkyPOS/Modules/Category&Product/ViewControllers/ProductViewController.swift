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
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No product"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
                    self.productRepo.addProduct(name: name, description: desc, price: price, image: image, category: category)
                    self.loadProducts()
                }
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true)
            }
        )
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = .systemBrown
        
        tableView.dataSource = self
        tableView.delegate = self
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
        products = productRepo.getProducts(byCategory: category)
        tableView.reloadData()
        emptyLabel.isHidden = !products.isEmpty
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
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .systemBackground
        
        let product = products[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                    
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            self.deleteProduct(at: indexPath)
            self.loadProducts()
            completion(true)
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
                self.editProduct(at: indexPath, newName: text, newImage: image, newPrice: price, newDesc: desc)
                self.loadProducts()
            }
            self.present(vc, animated: true)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func deleteProduct(at indexPath: IndexPath) {
        let product = products[indexPath.row]
        productRepo.deleteProduct(id: product._id)
        products.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    private func editProduct(at indexPath: IndexPath, newName: String, newImage: String, newPrice: Double, newDesc: String) {
        let product = products[indexPath.row]
        productRepo.updateProduct(id: product._id, newName: newName, newDescription: newDesc, newPrice: newPrice, newImage: newImage)
        products.remove(at: indexPath.row)
    }
}
