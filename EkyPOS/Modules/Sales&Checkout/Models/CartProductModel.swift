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
    @Persisted var totalUnit: Int = 0
    @Persisted var product: ProductModel?
}
