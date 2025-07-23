//
//  CategoryRepo.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import RealmSwift

class CategoryRepo {
    
    private var realm: Realm?
        
    init() {
        do {
            realm = try Realm()
        } catch {
            print("Realm initialization error: \(error.localizedDescription)")
        }
    }


    func addCategory(name: String, image: String) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                let newCategory = CategoryModel()
                newCategory.name = name
                newCategory.image = image
                realm.add(newCategory)
            }
        } catch {
            print("Add category failed: \(error.localizedDescription)")
        }
    }
    
    func getAllCategories() -> [CategoryModel] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(CategoryModel.self).sorted(byKeyPath: "createdAt"))
    }
    
    func updateCategory(id: String, newName: String, newImage: String?) {
        guard let realm = realm else { return }
        
        if let category = realm.object(ofType: CategoryModel.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    category.name = newName
                    if let image = newImage {
                        category.image = image
                    }
                }
            } catch {
                print("Update failed: \(error)")
            }
        }
    }
    
    func deleteCategory(id: String) {
        guard let realm = realm else { return }
        
        if let category = realm.object(ofType: CategoryModel.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Deletion failed: \(error)")
            }
        }
    }

}
