//
//  CartManager.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import Combine

class CartViewModel {
    
    static let shared = CartViewModel()
    private init() {}
    
    private let cartProductSubject = CurrentValueSubject<[CartProductModel], Never>([])
    var cartProducts: [CartProductModel] {
        get { cartProductSubject.value }
        set { cartProductSubject.send(newValue) }
    }

    var cartProductsPublisher: AnyPublisher<[CartProductModel], Never> {
        cartProductSubject.eraseToAnyPublisher()
    }
    
    private func addCartProduct(_ product: ProductModel) {
        let cartProduct = CartProductModel(product: product, total: 1)
        cartProducts.append(cartProduct)
        cartProductSubject.send(cartProducts)
    }
    
    private func removeCartProduct(_ product: ProductModel) {
        if let index = cartProducts.firstIndex(where: { $0.product == product }) {
            cartProducts.remove(at: index)
            cartProductSubject.send(cartProducts)
        }
    }
    
    func toggleProduct(_ product: ProductModel) {
        if cartProducts.contains(where: { $0.product == product }) {
            removeCartProduct(product)
        } else {
            addCartProduct(product)
        }
    }

    func incrementQuantity(for product: ProductModel) {
        guard let index = cartProducts.firstIndex(where: { $0.product == product }) else { return }
        cartProducts[index].total += 1
        cartProductSubject.send(cartProducts)
    }
    
    func decrementQuantity(for product: ProductModel) {
        guard let index = cartProducts.firstIndex(where: { $0.product == product }) else { return }
        if cartProducts[index].total > 1 {
            cartProducts[index].total -= 1
            cartProductSubject.send(cartProducts)
        }
    }

    func resetCart() {
        if !cartProducts.isEmpty {
            cartProducts.removeAll()
            cartProductSubject.send(cartProducts)
        }
    }
}
