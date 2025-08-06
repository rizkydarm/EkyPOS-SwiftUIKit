//
//  CategoryRepo.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import RealmSwift

class CategoryRepo {

    let realmManager = RealmManager.shared
    
    func addCategory(name: String, image: String, completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                do {
                    try realm.write {
                        let newCategory = CategoryModel()
                        newCategory.name = name
                        newCategory.image = image
                        realm.add(newCategory)
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
    
    func getAllCategories(completion: @escaping (Result<[CategoryModel], RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                let categories = realm.objects(CategoryModel.self).sorted(byKeyPath: "createdAt")
                completion(.success(Array(categories)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCategory(id: String, completion: @escaping (Result<CategoryModel, RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                if let category: CategoryModel = realm.object(ofType: CategoryModel.self, forPrimaryKey: id) {
                    completion(.success(category))
                } else {
                    completion(.failure(.objectNotFound(id)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateCategory(id: String, newName: String, newImage: String?, completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                if let category: CategoryModel = realm.object(ofType: CategoryModel.self, forPrimaryKey: id) {
                    do {
                        try realm.write {
                            category.name = newName
                            if let image = newImage, image != category.image {
                                category.image = image
                            }
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
    
    func deleteCategory(id: String, completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                if let category = realm.object(ofType: CategoryModel.self, forPrimaryKey: id) {
                    do {
                        try realm.write {
                            realm.delete(category)
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

}
