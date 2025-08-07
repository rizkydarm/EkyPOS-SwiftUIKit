//
//  ViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import SnapKit

class SalesViewController: UIViewController {
    
    private let productRepo = ProductRepo()
    private let categoryRepo = CategoryRepo()
    private var products: [ProductModel] = []
    private var categories: [CategoryModel] = []
    
    private lazy var cartViewModel = CartViewModel.shared
    
    private var selectedProducts: Set<ProductModel> = []

    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
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
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
        
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBrown
        button.tintColor = .label
        button.layer.cornerRadius = 8
        button.enableBounceAnimation()
        return button
    }()

    var isList = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Sales"
        view.backgroundColor = .systemBackground
        
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20, weight: .bold), scale: .large)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                self?.sideMenuController?.revealMenu()
            }
        )
        navigationItem.leftBarButtonItem = menuButton

        let optionButton = UIBarButtonItem(
            image: isList ? UIImage(systemName: "list.dash")?.withConfiguration(config) : UIImage(systemName: "square.grid.2x2.fill")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                guard let self = self else { return }
                self.toggleButtonType()
            }
        )
        navigationItem.rightBarButtonItem = optionButton

        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true

        navigationItem.hidesSearchBarWhenScrolling = true

        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .label
        
        navigationItem.searchController = searchController

        tableView.delegate = self
        tableView.dataSource = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.itemSize = CGSize(width: (view.bounds.width - 10) / 2, height: 200)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "gridcell")
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        tableView.contentInsetAdjustmentBehavior = .automatic
        collectionView.contentInsetAdjustmentBehavior = .automatic
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        
        collectionView.isHidden = true

        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        setupBottomBar()
    }

    private func rebuildUI() {
        view.subviews.forEach { $0.removeFromSuperview() }
        setupUI()
    }

    private func toggleButtonType() {
        isList.toggle()
        
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20, weight: .bold), scale: .large)
        navigationItem.rightBarButtonItem?.image = isList ? UIImage(systemName: "list.dash")?.withConfiguration(config) : UIImage(systemName: "square.grid.2x2.fill")?.withConfiguration(config)
        
        if isList {
            rebuildUI()
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            rebuildUI()
            tableView.isHidden = true
            collectionView.isHidden = false
        }

        selectedProducts.removeAll()
        cartViewModel.resetCart()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllProducts()
    }
    
    private func loadAllProducts() {
        productRepo.getAllProducts() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
                self.sortProductsByCategory()
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !products.isEmpty
            case .failure(let error):
                showToast(.error, vc: self, message: error.localizedDescription)
            }
        }
    }
    
    private func loadAllCategories() {
        categoryRepo.getAllCategories() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(let error):
                showToast(.error, vc: self, message: error.localizedDescription)
            }
        }
    }

    private func sortProductsByCategory() {
        let sortedProducts = products.sorted { $0.category?.name ?? "" < $1.category?.name ?? "" }
        self.products = sortedProducts
        tableView.reloadData()
    }
    
    private func setupBottomBar() {
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        bottomBar.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(bottomBar.snp.top).inset(20)
            make.bottom.equalTo(bottomBar.safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        actionButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.selectedProducts.isEmpty {
                showToast(.info, vc: self, message: "Please select at least one product", seconds: 1)
            } else {
                let vc = CheckoutViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, for: .touchUpInside)
    }

    deinit {
        selectedProducts.removeAll()
        cartViewModel.resetCart()
    }
}

extension SalesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let subLabel = UILabel()
        subLabel.textColor = .secondaryLabel
        subLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subLabel.text = rpCurrencyFormatter.string(from: product.price as NSNumber)
        cell.contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(config))
        checkmark.tintColor = .systemGreen
        checkmark.isHidden = !selectedProducts.contains(product)
        cell.contentView.addSubview(checkmark)
        checkmark.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }

        let categoryLabel = UILabel()
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        categoryLabel.text = product.category?.name ?? "-"
        categoryLabel.isHidden = selectedProducts.contains(product)
        cell.contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.performBatchUpdates({
            tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        tableView.deselectRow(at: indexPath, animated: true)
        
        let seletedProduct = products[indexPath.row]
        if selectedProducts.contains(seletedProduct) {
            selectedProducts.remove(seletedProduct)
        } else {
            selectedProducts.insert(seletedProduct)
        }
        
        cartViewModel.toggleProduct(seletedProduct)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


extension SalesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            loadAllProducts()
            return
        }
        productRepo.searchProducts(name: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
                self.tableView.reloadData()
                self.emptyLabel.isHidden = !products.isEmpty
            case .failure(let error):
                showToast(.error, vc: self, message: error.localizedDescription)
            }
        }
    }
}

extension SalesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let leftButton = self.navigationItem.leftBarButtonItem else {
            return
        }
        let isScrollingDown = scrollView.contentOffset.y > -90
        if isScrollingDown {
            leftButton.tintColor = .label
        } else {
            leftButton.tintColor = .systemBrown
        }
    }
}

extension SalesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridcell", for: indexPath)

        let product = products[indexPath.item]

        // cell.backgroundColor = selectedProducts.contains(product) ? .secondarySystemFill : .secondarySystemBackground
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true

        let emoji = UILabel()
        emoji.textColor = .label
        emoji.font = .systemFont(ofSize: 24, weight: .bold)
        emoji.text = product.image.containsEmoji ? product.image : "🟤"
        cell.contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
        }
        
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = product.name
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(emoji.snp.bottom).offset(20)
        }
        
        let subLabel = UILabel()
        subLabel.textColor = .secondaryLabel
        subLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subLabel.text = rpCurrencyFormatter.string(from: product.price as NSNumber)
        cell.contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(label.snp.bottom).offset(20)
        }

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(config))
        checkmark.tintColor = .systemGreen
        checkmark.isHidden = !selectedProducts.contains(product)
        cell.contentView.addSubview(checkmark)
        checkmark.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(subLabel.snp.bottom).offset(20)
            make.width.height.equalTo(30)
        }

        let categoryLabel = UILabel()
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        categoryLabel.text = product.category?.name ?? "-"
        cell.contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
        }
        return cell
    }   

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)   
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // collectionView.performBatchUpdates({
        //     collectionView.reloadItems(at: [indexPath])
        // })
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        // let seletedProduct = products[indexPath.item]
        // if selectedProducts.contains(seletedProduct) {
        //     selectedProducts.remove(seletedProduct)
        // } else {
        //     selectedProducts.insert(seletedProduct)
        // }
        
        // cartViewModel.toggleProduct(seletedProduct)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 17.0, *)
#Preview("SalesViewController (iOS 17+)") {
    SalesViewController()
}
//@available(iOS 13.0, *)
//struct SalesViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            SalesViewController()
//        }
//        .previewDisplayName("SalesViewController (Legacy)")
//    }
//}
#endif
