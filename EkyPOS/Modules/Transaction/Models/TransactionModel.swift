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
    @Persisted var totalPrice: Double
    @Persisted var totalUnit: Int
    @Persisted var changes: Double
    @Persisted var paymentMethod: String
    @Persisted var products: List<ProductModel>
}

