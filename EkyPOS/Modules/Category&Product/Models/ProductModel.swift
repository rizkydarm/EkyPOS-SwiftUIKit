//
//  ProductModel.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import RealmSwift

class ProductModel: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    @Persisted var name: String = ""
    @Persisted var desc: String = ""
    @Persisted var price: Double = 0.0
    @Persisted var image: String = ""
    @Persisted var category: CategoryModel?
}

extension ProductModel {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs._id == rhs._id
    }
}

