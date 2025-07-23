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
