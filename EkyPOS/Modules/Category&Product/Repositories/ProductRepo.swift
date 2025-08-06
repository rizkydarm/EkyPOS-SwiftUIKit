//
//  ProductRepo.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import RealmSwift

class ProductRepo {
    
    let realmManager = RealmManager.shared
    
    func addProduct(
        name: String,
        description: String,
        price: Double,
        image: String,
        category: CategoryModel,
        completion: @escaping (Result<Void, RepositoryError>) -> Void
    ) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                do {
                    try realm.write {
                        let newProduct = ProductModel()
                        newProduct.name = name
                        newProduct.desc = description
                        newProduct.price = price
                        newProduct.image = image
                        newProduct.category = category
                        realm.add(newProduct)
                        completion(.success(()))
                    }
                } catch {
                    completion(.failure(.realmWriteFailed(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAllProducts(completion: @escaping (Result<[ProductModel], RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                let products = realm.objects(ProductModel.self).sorted(byKeyPath: "name")
                completion(.success(Array(products)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getProducts(byCategory category: CategoryModel, completion: @escaping (Result<[ProductModel], RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                let products = realm.objects(ProductModel.self)
                    .filter("category._id == %@", category._id)
                    .sorted(byKeyPath: "name")
                completion(.success(Array(products)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProduct(
        id: String,
        newName: String? = nil,
        newDesc: String? = nil,
        newPrice: Double? = nil,
        newImage: String? = nil,
        newCategory: CategoryModel? = nil,
        completion: @escaping (Result<Void, RepositoryError>) -> Void
    ) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                if let product = realm.object(ofType: ProductModel.self, forPrimaryKey: id) {
                    do {
                        try realm.write {
                            if let newName = newName { product.name = newName }
                            if let newDesc = newDesc { product.desc = newDesc }
                            if let newPrice = newPrice { product.price = newPrice }
                            if let newImage = newImage, newImage != product.image { product.image = newImage }
                            if let newCategory = newCategory { product.category = newCategory }
                        }
                        completion(.success(()))
                    } catch {
                        completion(.failure(.realmWriteFailed(error)))
                    }
                } else {
                    completion(.failure(.objectNotFound(id)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteProduct(id: String, completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                if let product = realm.object(ofType: ProductModel.self, forPrimaryKey: id) {
                    do {
                        try realm.write {
                            realm.delete(product)
                        }
                        completion(.success(()))
                    } catch {
                        completion(.failure(.realmWriteFailed(error)))
                    }
                } else {
                    completion(.failure(.objectNotFound(id)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchProducts(name: String, completion: @escaping (Result<[ProductModel], RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                let products = realm.objects(ProductModel.self)
                    .filter("name CONTAINS[c] %@", name)
                    .sorted(byKeyPath: "name")
                completion(.success(Array(products)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getProductsInPriceRange(min: Double, max: Double, completion: @escaping (Result<[ProductModel], RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                let products = realm.objects(ProductModel.self)
                    .filter("price BETWEEN {%@, %@}", min, max)
                    .sorted(byKeyPath: "price")
                completion(.success(Array(products)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
