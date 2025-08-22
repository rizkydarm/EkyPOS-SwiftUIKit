
import IGListKit
import UIKit

final class ProductSectionController: ListBindingSectionController<CategorySectionModel> {

    override required init() {
        super.init()
        minimumInteritemSpacing = 0
        minimumLineSpacing = 10
        inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        self.selectionDelegate = self
        self.supplementaryViewSource = self    
    }

    override func numberOfItems() -> Int {
        return object?.products.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width - inset.left - inset.right, height: 80)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let category = object else { return UICollectionViewCell() }
        guard let viewController = self.viewController as? SalesViewController else { return UICollectionViewCell() }
        
        let cell = collectionContext?.dequeueReusableCell(of: ProductListCell.self, for: self, at: index) as? ProductListCell ?? ProductListCell()
        let product = category.products[index]
        
        cell.bindViewModel(product)
        cell.setSelected(viewController.isSelected(product: product))
        
        return cell
    }
}

extension ProductSectionController: ListBindingSectionControllerSelectionDelegate {
    func sectionController(_ sectionController: ListBindingSectionController<any ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {

        guard let category: CategorySectionModel = sectionController.object as? CategorySectionModel else { return }
        let product = category.products[index]
        
        Debouncer.debounce(identifier: "selectItem_\(index)_\(product._id)", delay: 0.1) { [weak self] in
            guard let self: ProductSectionController = self, let viewController = self.viewController as? SalesViewController else { return }

            var wasSelected = viewController.isSelected(product: product)
            if wasSelected {
                viewController.deselectProduct(product: product)
            } else {
                viewController.selectProduct(product: product)
            }
            wasSelected = viewController.isSelected(product: product)

            collectionContext?.performBatch(animated: true, updates: { batchContext in
                batchContext.reload(in: self, at: IndexSet(integer: index))
            }, completion: nil)
        }
    }

    func sectionController(_ sectionController: ListBindingSectionController<any ListDiffable>, didDeselectItemAt index: Int, viewModel: Any) {
        
    }

    func sectionController(_ sectionController: ListBindingSectionController<any ListDiffable>, didHighlightItemAt index: Int, viewModel: Any) {
        // print("Highlighted item at index: \(index)")
    }

    func sectionController(_ sectionController: ListBindingSectionController<any ListDiffable>, didUnhighlightItemAt index: Int, viewModel: Any) {
        // print("Unhighlighted item at index: \(index)")
    }
}

extension ProductSectionController: ListSupplementaryViewSource {  
      
    func supportedElementKinds() -> [String] {  
        return [UICollectionView.elementKindSectionHeader]  
    }  
      
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {  
        guard let context = collectionContext else { fatalError("Missing collection context") }  
          
        if elementKind == UICollectionView.elementKindSectionHeader {  
            let headerView = context.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: HeaderProductListCell.self, at: index)  as? HeaderProductListCell ?? HeaderProductListCell()
            headerView.name = object?.category.name
            return headerView  
        } 
          
        fatalError("Unsupported element kind")  
    }  
      
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {  
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: 50) 
    }  
}
