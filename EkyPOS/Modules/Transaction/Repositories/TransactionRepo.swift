//
//  TransactionRepo.swift
//  EkyPOS
//
//  Created by Eky on 25/07/25.
//

import RealmSwift

class TransactionRepo {
    
    let realmManager = RealmManager.shared

    func addTransaction(
        totalPrice: Double, 
        totalUnit: Int, 
        changes: Double, 
        paymentMethod: String, 
        products: List<CartProductModel>,
        completion: @escaping (Result<Void, RepositoryError>) -> Void
    ) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                do {
                    try realm.write {
                        let newTransaction = TransactionModel()
                        newTransaction.totalPrice = totalPrice
                        newTransaction.totalUnit = totalUnit
                        newTransaction.changes = changes
                        newTransaction.paymentMethod = paymentMethod
                        newTransaction.cartProducts = products
                        realm.add(newTransaction)
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
    
    func getAllTransactions(completion: @escaping (Result<[TransactionModel], RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                let transactions = realm.objects(TransactionModel.self).sorted(byKeyPath: "createdAt")
                completion(.success(Array(transactions)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTransaction(id: String, completion: @escaping (Result<Void, RepositoryError>) -> Void) {
        realmManager.setup { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let realm):
                if let transaction = realm.object(ofType: TransactionModel.self, forPrimaryKey: id) {
                    do {
                        try realm.write {
                            realm.delete(transaction)
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
