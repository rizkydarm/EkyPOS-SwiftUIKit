//
//  ErrorRepo.swift
//  EkyPOS
//
//  Created by Eky on 05/08/25.
//

import Foundation

enum RepositoryError: Error, LocalizedError {
    case realmNotInitialized
    case realmWriteFailed(Error)
    case realmReadFailed(Error)
    
    case invalidInput(String)
    case objectNotFound(String)
    
    case duplicateProduct(String)
    case invalidPrice
    
    var errorDescription: String? {
        switch self {
        case .realmNotInitialized:
            return "Database not initialized. Please restart the app."
        case .realmWriteFailed(let error):
            return "Failed to save data: \(error.localizedDescription)"
        case .realmReadFailed(let error):
            return "Failed to read data: \(error.localizedDescription)"
        case .invalidInput(let field):
            return "Invalid input for field: \(field)"
        case .objectNotFound(let id):
            return "Object not found with ID: \(id)"
        case .duplicateProduct(let name):
            return "Product with name '\(name)' already exists"
        case .invalidPrice:
            return "Price must be greater than zero"
        }
    }
}
