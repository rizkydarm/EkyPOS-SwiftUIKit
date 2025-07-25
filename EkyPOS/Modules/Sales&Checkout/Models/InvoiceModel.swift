//
//  selectedProducts.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import Foundation

class InvoiceModel: NSObject {
    var checkout: CheckoutModel
    var createdAt: Date
    var changes: Double
    var paymentMethod: String
    
    init(checkout: CheckoutModel, paymentMethod: String, changes: Double = 0, createdAt: Date = Date()) {
        self.checkout = checkout
        self.changes = changes
        self.createdAt = createdAt
        self.paymentMethod = paymentMethod
    }
}
