import Foundation
import IGListKit

class CategorySectionModel: NSObject {
    let category: CategoryModel
    let products: [ProductModel]

    init(category: CategoryModel, products: [ProductModel]) {
        self.category = category
        self.products = products
    }
}

extension CategorySectionModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return category._id as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? CategorySectionModel else { return false }
        guard self.category._id == other.category._id else { return false }
        guard self.products.count == other.products.count else { return false }
        for (index, product) in self.products.enumerated() {
            if product._id != other.products[index]._id {
                return false
            }
        }
        return true
    }
}