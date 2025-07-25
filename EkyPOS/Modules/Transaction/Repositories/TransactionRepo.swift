//
//  TransactionRepo.swift
//  EkyPOS
//
//  Created by Eky on 25/07/25.
//

import RealmSwift

class TransactionRepo {
    
    private var realm: Realm?
        
    init() {
        do {
            realm = try Realm()
        } catch {
            print("Realm initialization error: \(error.localizedDescription)")
        }
    }


    func addTransaction(totalPrice: Double, totalUnit: Int, changes: Double, paymentMethod: String, products: List<ProductModel>) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                let newTransaction = TransactionModel()
                newTransaction.totalPrice = totalPrice
                newTransaction.totalUnit = totalUnit
                newTransaction.changes = changes
                newTransaction.paymentMethod = paymentMethod
                newTransaction.products = products
                realm.add(newTransaction)
            }
        } catch {
            print("Add transaction failed: \(error.localizedDescription)")
        }
    }
    
    func getAllTransactions() -> [TransactionModel] {
        guard let realm = realm else { return [] }
        return Array(realm.objects(TransactionModel.self).sorted(byKeyPath: "createdAt"))
    }
    
    func deleteTransaction(id: String) {
        guard let realm = realm else { return }
        
        if let transaction = realm.object(ofType: TransactionModel.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    realm.delete(transaction)
                }
            } catch {
                print("Deletion failed: \(error)")
            }
        }
    }

}