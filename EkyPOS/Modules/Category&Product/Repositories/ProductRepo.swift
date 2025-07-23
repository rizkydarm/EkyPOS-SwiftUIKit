//
//  ProductRepo.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import RealmSwift

class ProductRepo {
    private var realm: Realm?
    
    init() {
        do {
            realm = try Realm()
        } catch {
            print("Realm initialization error: \(error.localizedDescription)")
        }
    }
    
    func addProduct(
        name: String,
        description: String,
        price: Double,
        image: String,
        category: CategoryModel
    ) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                let newProduct = ProductModel()
                newProduct.name = name
                newProduct.desc = description
                newProduct.price = price
                newProduct.image = image
                newProduct.category = category
                realm.add(newProduct)
            }
        } catch {
            print("Add product failed: \(error.localizedDescription)")
        }
    }
    
    func getAllProducts() -> [ProductModel] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(ProductModel.self).sorted(byKeyPath: "name"))
    }
    
    func getProducts(byCategory category: CategoryModel) -> [ProductModel] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(ProductModel.self)
            .filter("category._id == %@", category._id)
            .sorted(byKeyPath: "name"))
    }
    
    func updateProduct(
        id: String,
        newName: String? = nil,
        newDescription: String? = nil,
        newPrice: Double? = nil,
        newImage: String? = nil,
        newCategory: CategoryModel? = nil
    ) {
        guard let realm = realm else { return }
        
        if let product = realm.object(ofType: ProductModel.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    if let newName = newName { product.name = newName }
                    if let newDescription = newDescription { product.desc = newDescription }
                    if let newPrice = newPrice { product.price = newPrice }
                    if let newImage = newImage { product.image = newImage }
                    if let newCategory = newCategory { product.category = newCategory }
                }
            } catch {
                print("Update failed: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteProduct(id: String) {
        guard let realm = realm else { return }
        
        if let product = realm.object(ofType: ProductModel.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    realm.delete(product)
                }
            } catch {
                print("Deletion failed: \(error.localizedDescription)")
            }
        }
    }
    
    func searchProducts(name: String) -> [ProductModel] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(ProductModel.self)
            .filter("name CONTAINS[c] %@", name)
            .sorted(byKeyPath: "name"))
    }
    
    func getProductsInPriceRange(min: Double, max: Double) -> [ProductModel] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(ProductModel.self)
            .filter("price BETWEEN {%@, %@}", min, max)
            .sorted(byKeyPath: "price"))
    }
}
