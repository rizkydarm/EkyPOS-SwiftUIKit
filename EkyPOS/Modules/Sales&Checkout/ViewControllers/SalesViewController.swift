//
//  ViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import SnapKit
import IGListKit

class SalesViewController: UIViewController {
    
    private let productRepo = ProductRepo()
    private let categoryRepo = CategoryRepo()
    private var products: [ProductModel] = [] {
        didSet {
            updateSectionedData()
        }
    }
    private var sectionedData: [CategorySectionModel] = [] {
        didSet {
            listAdapter.performUpdates(animated: true)
        }
    }
    
    private lazy var cartViewModel = CartViewModel.shared
    
    private var selectedProducts: Set<ProductModel> = []

    private let searchSalesController: SearchSalesViewController = SearchSalesViewController()
    private lazy var searchController: UISearchController = UISearchController(searchResultsController: searchSalesController)

    private lazy var listCollectionView: ListCollectionView = {
        let collection = ListCollectionView(frame: .zero)
        collection.backgroundColor = .clear
        collection.collectionViewLayout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: false)
        return collection
    }()

    lazy var listAdapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        return adapter
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

    public var mainAppRootNavController: UINavigationController?
    public var menuIndexPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        (searchController.searchResultsController as? SearchSalesViewController)?.salesViewController = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllProducts()
        setBottomBar(size: view.bounds.size)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setBottomBar(size: size)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listCollectionView.collectionViewLayout.invalidateLayout()
    }

    private func setBottomBar(size: CGSize) {
        if size.width > 800 {
            bottomBar.isHidden = true
        } else {
            bottomBar.isHidden = false
        }
    }

    private func setupUI() {
        title = "Sales"
        view.backgroundColor = .systemBackground
        
        addMenuButton(mainAppRootNavController: mainAppRootNavController ?? rootNavigationController, menuIndexPage: menuIndexPage)
        addSearchBar()

        view.addSubview(listCollectionView)
        
        listAdapter.dataSource = self 
        
        // listCollectionView.alwaysBounceHorizontal = true
        // listCollectionView.alwaysBounceVertical = true
        // listCollectionView.isPagingEnabled = true
        // listCollectionView.isScrollEnabled = true
        // listCollectionView.isDirectionalLockEnabled = true
        // listCollectionView.isPrefetchingEnabled = true

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        listAdapter.collectionView = listCollectionView

        listAdapter.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)

        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        addBottomBar()

        loadAllProducts()
    }
    
    private func loadAllProducts() {
        productRepo.getAllProducts() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
                self.emptyLabel.isHidden = !products.isEmpty
            case .failure(let error):
                showToast(.warning, title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func addSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true

        navigationItem.hidesSearchBarWhenScrolling = true
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .stacked
        }

        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.tintColor = .label
        
        navigationItem.searchController = searchController
    }
    
    private func addBottomBar() {
        
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
                showToast(.warning, title: "Info", message: "Please select at least one product")
            } else {
                let vc = CheckoutViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, for: .touchUpInside)

        setBottomBar(size: view.bounds.size)
    }

    deinit {
        selectedProducts.removeAll()
        cartViewModel.resetCart()
    }
}

extension SalesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            searchSalesController.searchResults = []
        } else {
            productRepo.searchProducts(name: searchText) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let products):
                    self.searchSalesController.searchResults = products
                case .failure(let error):
                    showToast(.warning, title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    func searchController(_ searchController: UISearchController, didCancelSearch searchResults: [ProductModel]) {
        print("cancel")
    }

    func searchController(_ searchController: UISearchController, didDismissSearch searchResults: [ProductModel]) {
        print("dismiss")
    }
}

// extension SalesViewController: UIScrollViewDelegate {
//     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//         guard let leftButton = self.navigationItem.leftBarButtonItem else {
//             return
//         }
//         let isScrollingDown = scrollView.contentOffset.y > -90
//         if isScrollingDown {
//             leftButton.tintColor = .label
//         } else {
//             leftButton.tintColor = .systemBrown
//         }
//     }
// }

extension SalesViewController: ListAdapterDataSource {

    private func updateSectionedData() {
        let groupedProducts = Dictionary(grouping: products) { product in
            return product.category ?? CategoryModel()
        }
        var sections: [CategorySectionModel] = []
        let sortedCategories = groupedProducts.keys.sorted { $0.name < $1.name }

        for category in sortedCategories {
            if let products = groupedProducts[category] {
                let sortedProducts = products.sorted { $0.name < $1.name }
                let section = CategorySectionModel(category: category, products: sortedProducts)
                sections.append(section)
            }
        }
        self.sectionedData = sections
    }

    func isSelected(product: ProductModel) -> Bool {        
        return selectedProducts.contains(product)
    }

    func selectProduct(product: ProductModel) {
        selectedProducts.insert(product)
        cartViewModel.toggleProduct(product)
    }

    func deselectProduct(product: ProductModel) {
        selectedProducts.remove(product)
        cartViewModel.toggleProduct(product)
    }
    
    func objects(for listAdapter: ListAdapter) -> [any ListDiffable] {
        return sectionedData as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ProductSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }
}

#if canImport(SwiftUI) && DEBUG
//import SwiftUI

//@available(iOS 17.0, *)
//#Preview("SalesViewController (iOS 17+)") {
//    SalesViewController()
//}
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
