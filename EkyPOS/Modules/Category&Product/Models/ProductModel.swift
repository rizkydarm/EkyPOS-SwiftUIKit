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
    @Persisted var category: CategoryModel?
    @Persisted var name: String
    @Persisted var desc: String = ""
    @Persisted var price: Double
    @Persisted var image: String = ""
}

extension ProductModel {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs._id == rhs._id // Primary key comparison
    }
}

