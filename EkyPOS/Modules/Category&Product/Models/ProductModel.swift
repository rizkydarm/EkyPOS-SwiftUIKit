//
//  ProductModel.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import Foundation
import RealmSwift
import IGListKit

class ProductModel: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    @Persisted var name: String = ""
    @Persisted var desc: String = ""
    @Persisted var price: Double = 0.0
    @Persisted var cost: Double = 0.0
    @Persisted var stock: Int = 0
    @Persisted var barcode: String = ""
    @Persisted var image: String = ""
    @Persisted var category: CategoryModel?
}

extension ProductModel {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs._id == rhs._id
    }
}

extension ProductModel: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return _id as NSString
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ProductModel else {
            return false
        }
        
        if _id != object._id || name != object.name {
            return false
        }
        
        return self == object
    }
}

