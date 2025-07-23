//
//  Category.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import RealmSwift

class CategoryModel: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var createdAt: Date = Date()
}
