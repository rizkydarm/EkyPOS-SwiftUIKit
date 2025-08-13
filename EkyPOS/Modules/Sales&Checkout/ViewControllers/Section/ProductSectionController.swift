
import IGListKit
import UIKit

final class ProductSectionController: ListSectionController {

    private var categorySection: CategorySectionModel?
    private var selectedIndexes: Set<Int> = []

    override required init() {
        super.init()
        minimumInteritemSpacing = 20
        minimumLineSpacing = 20
        inset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }

    override func numberOfItems() -> Int {
        return (categorySection?.products.count ?? 0) + 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        if index == 0 {
            return CGSize(width: context.containerSize.width - inset.left - inset.right, height: 50)
        } else { 
            return CGSize(width: context.containerSize.width - inset.left - inset.right, height: 80)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let categorySection = categorySection else { return UICollectionViewCell() }

        if index == 0 {
            let cell = collectionContext?.dequeueReusableCell(of: ProductListCell.self, for: self, at: index) as? ProductListCell ?? ProductListCell()
            let category = categorySection.category
            cell.name = category.name
            return cell
        } else {
            let productIndex = index - 1
            let cell = collectionContext?.dequeueReusableCell(of: ProductListCell.self, for: self, at: index) as? ProductListCell ?? ProductListCell()
            let product = categorySection.products[productIndex]

            cell.name = product.name
            cell.emoji = product.image.containsEmoji ? product.image : "🟤"
            cell.price = rpCurrencyFormatter.string(from: product.price as NSNumber)
            cell.category = product.category?.name ?? "-"
        
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        categorySection = object as? CategorySectionModel
    }

    override func didSelectItem(at index: Int) {
        
        guard index > 0, let categorySection = categorySection, let viewController = viewController as? SalesViewController else { return }

        let productIndex = index - 1 // Adjust for header
        guard productIndex < categorySection.products.count else { return }
        let product = categorySection.products[productIndex]

        let wasSelected = viewController.isSelected(product: product)

        if wasSelected {
            viewController.deselectProduct(product: product)
        } else {
            viewController.selectProduct(product: product)
        }

        if let cell = collectionContext?.cellForItem(at: index, sectionController: self) as? ProductListCell {
            cell.setSelected(wasSelected)
        }
    }
}