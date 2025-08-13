//
//  ViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import SnapKit
import IGListKit
import SideMenu

class SalesViewController: UIViewController {
    
    private let productRepo = ProductRepo()
    private let categoryRepo = CategoryRepo()
    private var products: [ProductModel] = []
    private var categories: [CategoryModel] = []
    
    private lazy var cartViewModel = CartViewModel.shared
    
    private var selectedProducts: Set<ProductModel> = []

    private lazy var searchController = UISearchController(searchResultsController: nil)

    private lazy var listCollectionView: ListCollectionView = {
        let collection = ListCollectionView(frame: .zero)
        collection.backgroundColor = .clear
        collection.collectionViewLayout = ListCollectionViewLayout(stickyHeaders: true, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true)
        return collection
    }()

    lazy var listAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
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

    private var isList = true
    
    private var isTabletMode: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    private let menuVC = SideMenuNavigationController(rootViewController: MenuViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Sales"
        view.backgroundColor = .systemBackground

        splitViewController?.preferredPrimaryColumnWidthFraction = 0.5
        
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20, weight: .bold), scale: .large)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                guard let self = self else { return }
                self.menuVC.leftSide = true
                self.menuVC.menuWidth = 300
                self.menuVC.animationOptions = .curveEaseOut
                self.menuVC.presentationStyle = .menuSlideIn
                self.menuVC.edgesForExtendedLayout = .left
                self.present(self.menuVC, animated: true)
            }
        )
        navigationItem.leftBarButtonItem = menuButton
        
        // if !isTabletMode {
        //     let optionButton = UIBarButtonItem(
        //         image: isList ? UIImage(systemName: "list.dash")?.withConfiguration(config) : UIImage(systemName: "square.grid.2x2.fill")?.withConfiguration(config),
        //         primaryAction: UIAction { [weak self] _ in
        //             guard let self = self else { return }
        //             self.toggleButtonType()
        //         }
        //     )
        //     navigationItem.rightBarButtonItem = optionButton
        // }

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

        view.addSubview(listCollectionView)
        
        // if let layout = listCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        //     layout.minimumInteritemSpacing = 10
        //     layout.minimumLineSpacing = 10
        //     layout.itemSize = CGSize(width: (view.bounds.width - 10) / 2, height: 200)
        // }

        listAdapter.collectionView = listCollectionView
        listAdapter.dataSource = self 

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        if !isTabletMode {
            setupBottomBar()
        }
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
                self.emptyLabel.isHidden = !products.isEmpty
            case .failure(let error):
                showBanner(.warning, title: "Error", message: error.localizedDescription)
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
                showBanner(.warning, title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func sortProductsByCategory() {
        let sortedProducts = products.sorted { $0.category?.name ?? "" < $1.category?.name ?? "" }
        self.products = sortedProducts
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
                showBanner(.warning, title: "Info", message: "Please select at least one product")
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
                // self.tableView.reloadData()
                self.emptyLabel.isHidden = !products.isEmpty
            case .failure(let error):
                showBanner(.warning, title: "Error", message: error.localizedDescription)
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

extension SalesViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [any ListDiffable] {
        print("Product count: \(products.count)")
        return products
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ProductSectionController()
        sectionController.product = object as? ProductModel
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        return view
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
