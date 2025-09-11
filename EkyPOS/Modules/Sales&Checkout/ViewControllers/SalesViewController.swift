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
    private var searchResultProducts: [ProductModel] = [] {
        didSet {
            listAdapter.performUpdates(animated: true)
        }
    }
    
    public lazy var cartViewModel = CartViewModel.shared
    
    public var selectedProducts: Set<ProductModel> = []

    private lazy var searchController: UISearchController = UISearchController(searchResultsController: nil)

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

    public var mainAppRootNavController: UINavigationController?
    public var menuIndexPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        listAdapter.collectionView = listCollectionView

        listAdapter.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReset),
            name: .resetSalesVC,
            object: nil
        )

        addBottomBar()
        loadAllProducts()

        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(showMenu(_:))
        )
        
        let styleButton = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet.indent"),
            style: .plain,
            target: self,
            action: #selector(changeStyle(_:))
        )
        
        navigationItem.rightBarButtonItems = [menuButton, styleButton]

        allCategories = getAllCategory()
    }

    private var isList = true
    @objc private func changeStyle(_ sender: UIBarButtonItem) {
        sender.image = isList ? UIImage(systemName: "list.bullet.indent") : UIImage(systemName: "rectangle.grid.2x2")
        isList.toggle()
    }

    private var allCategories: [CategoryModel] = []
    private var selectedCategories: Set<CategoryModel> = []
    private var tempSectionedData: [CategorySectionModel] = []
    @objc private func showMenu(_ sender: UIBarButtonItem) {
        let menuVC: CategoryOptionViewController = CategoryOptionViewController()
        menuVC.availableCategories = allCategories
        menuVC.selectedCategories = selectedCategories
        menuVC.didChangeCategory = { [weak self] selectedCategories, unSelectedCategories in
            guard let self = self else { return }
            self.selectedCategories = unSelectedCategories
            self.sectionedData = self.tempSectionedData.filter { selectedCategories.contains($0.category) }
            // self.listAdapter.performUpdates(animated: true)
        }
        menuVC.modalPresentationStyle = .popover
        menuVC.preferredContentSize = CGSize(width: 240, height: 300)
        menuVC.popoverPresentationController?.barButtonItem = sender
        menuVC.popoverPresentationController?.permittedArrowDirections = .up
        menuVC.popoverPresentationController?.delegate = self // keep arrow & placement
        present(menuVC, animated: true)
    }

    @objc func handleReset() {
        selectedProducts.removeAll()
        cartViewModel.resetCart()
        listCollectionView.reloadData()
        listAdapter.performUpdates(animated: true)
    }
    
    private func loadAllProducts() {
        productRepo.getAllProducts() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                showToast(.warning, title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func getAllCategory() -> [CategoryModel] {
        return sectionedData.map { $0.category }
    }

    private func addSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.hidesSearchBarWhenScrolling = true
        if #available(iOS 16.0, *) {
            navigationItem.preferredSearchBarPlacement = .stacked
        }

        searchController.searchBar.searchBarStyle = .minimal
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
        NotificationCenter.default.removeObserver(self, name: .resetSalesVC, object: nil)
    }
}

extension SalesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            searchResultProducts = []
        } else {
            productRepo.searchProducts(name: searchText) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let products):
                    self.searchResultProducts = products
                case .failure(let error):
                    showToast(.warning, title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        searchResultProducts = []
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        searchResultProducts = []
    }
}

extension SalesViewController {
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
        self.tempSectionedData = self.sectionedData
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
}

extension SalesViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [any ListDiffable] {
        if searchController.isActive {
            let sectionedData = CategorySectionModel(category: CategoryModel(), products: searchResultProducts)
            return [sectionedData] as [ListDiffable]
        } else {
            return sectionedData as [ListDiffable]
        }
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ProductSectionController()
        sectionController.isSearchMode = searchController.isActive
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "No product found"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }
}

extension SalesViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        // Handle popover dismissal if needed
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
