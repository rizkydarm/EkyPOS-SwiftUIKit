//
//  selectedProducts.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import Foundation
import RealmSwift

class CartProductModel: Object {
    
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var product: ProductModel
    @Persisted var total: Int
    
    init(product: ProductModel, total: Int) {
        self.product = product
        self.total = total
    }
}
