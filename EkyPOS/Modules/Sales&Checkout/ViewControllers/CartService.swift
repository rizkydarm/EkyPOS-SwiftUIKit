//
//  CartManager.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import Combine

class CartManager {
    
    static let shared = CartManager()
    private init() {}
    
    @Published private(set) var selectedProducts: [ProductModel] = []
    
    func addProduct(_ product: ProductModel) {
        selectedProducts.append(product)
    }
    
    func removeProduct(_ product: ProductModel) {
        selectedProducts.removeAll { $0.id == product.id }
    }
    
    func clearCart() {
        selectedProducts.removeAll()
    }
    
    func toggleProduct(_ product: ProductModel) {
        if selectedProducts.contains(where: { $0.id == product.id }) {
            removeProduct(product)
        } else {
            addProduct(product)
        }
    }
}
