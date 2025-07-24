//
//  selectedProducts.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import Foundation

class CartProductModel: NSObject {
    var product: ProductModel
    var total: Int
    
    init(product: ProductModel, total: Int) {
        self.product = product
        self.total = total
    }
}
