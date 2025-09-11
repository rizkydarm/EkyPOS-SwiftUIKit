//
//  TransactionModel.swift
//  EkyPOS
//
//  Created by Eky on 25/07/25.
//

import RealmSwift

class TransactionModel: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var createdAt: Date = Date()
    @Persisted var totalPrice: Double = 0.0
    @Persisted var totalUnit: Int = 0
    @Persisted var changes: Double = 0.0
    @Persisted var paymentMethod: String = ""
    @Persisted var cartProducts: List<CartProductModel>
}

