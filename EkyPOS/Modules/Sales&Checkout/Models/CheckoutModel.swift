//
//  selectedProducts.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import Foundation

class CheckoutModel: NSObject {
    var cartProducts: [CartProductModel]
    var totalPrice: Double
    var totalUnit: Int
    
    init(cartProducts: [CartProductModel], totalPrice: Double, totalUnit: Int) {
        self.cartProducts = cartProducts
        self.totalPrice = totalPrice
        self.totalUnit = totalUnit
    }
}
