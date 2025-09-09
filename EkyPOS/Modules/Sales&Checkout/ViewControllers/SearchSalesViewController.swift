import UIKit

class SearchSalesViewController: UIViewController {
    private lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    public var searchResults: [ProductModel] = [] {
        didSet {
            collection.reloadData()
        }
    }

    public var salesViewController: SalesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }
    
    private func setupCollection() {
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(ProductListCell.self, forCellWithReuseIdentifier: "SearchResultCell")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.itemSize = CGSize(width: view.bounds.width - layout.sectionInset.left - layout.sectionInset.right, height: 80)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
        }
    }
}

extension SearchSalesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! ProductListCell
        cell.bindViewModel(searchResults[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let product = searchResults[indexPath.row]

        Debouncer.debounce(identifier: "selectItem_\(indexPath.row)_\(product._id)", delay: 0.1) { [weak self] in
            
            guard let salesViewController = self?.salesViewController else { return }

            var wasSelected = salesViewController.isSelected(product: product)
            if wasSelected {
                salesViewController.deselectProduct(product: product)
            } else {
                salesViewController.selectProduct(product: product)
            }
            wasSelected = salesViewController.isSelected(product: product)

            let cell = collectionView.cellForItem(at: indexPath) as! ProductListCell
            cell.setSelected(wasSelected)
        }   
    }
}