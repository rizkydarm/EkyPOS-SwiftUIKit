//
//  RealmManager.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//

import RealmSwift

// Singleton Realm Manager
class RealmManager {
    static let shared = RealmManager()
    private var realm: Realm?
        
    func setup(completion: @escaping (Result<Realm, RepositoryError>) -> Void) {
        if realm == nil {
            do {
                realm = try Realm()
            } catch {
                completion(.failure(.realmNotInitialized))
            }
        }
        guard let realm = self.realm else {
            completion(.failure(.realmNotInitialized))
            return
        }
        completion(.success(realm))
    }
    
    func refresh() -> Result<Void, Error> {
        do {
            self.realm = try Realm()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
