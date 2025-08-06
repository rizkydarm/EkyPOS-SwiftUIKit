//
//  RepoError.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//


enum RepoError: Error {
    case realmNotInitialized
}

extension Results {
    func toArray() -> [Element] {
        return Array(self)
    }
}