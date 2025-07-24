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
    private var products: [ProductModel] = []
    
    private let cartViewModel = CartViewModel.shared
    
    private var selectedProducts: Set<ProductModel> = []

    private let searchController = UISearchController(searchResultsController: nil)
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
    
    private let bottomBar: UIView = {
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
        
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBrown
        button.tintColor = .label
        button.layer.cornerRadius = 8
        button.enableBounceAnimation()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sales"
        view.backgroundColor = .systemBackground
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                self?.sideMenuController?.revealMenu()
            }
        )
        navigationItem.leftBarButtonItem = menuButton
        
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        setupBottomBar()
        
        loadAllProducts()
    }
    
    private func loadAllProducts() {
        products = productRepo.getAllProducts()
        tableView.reloadData()
        emptyLabel.isHidden = !products.isEmpty
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
            if self?.selectedProducts.isEmpty == true {
                showToast(.info, vc: self!, message: "Please select at least one product", seconds: 1)
            } else {
                let vc = CheckoutViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }, for: .touchUpInside)
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
        products = productRepo.searchProducts(name: searchText)
        tableView.reloadData()
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

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 17.0, *)
#Preview("SalesViewController (iOS 17+)") {
    SalesViewController()
}
@available(iOS 13.0, *)
struct SalesViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SalesViewController()
        }
        .previewDisplayName("SalesViewController (Legacy)")
    }
}
#endif
