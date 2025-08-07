//
//  Debouncer.swift
//  EkyPOS
//
//  Created by Eky on 06/08/25.
//
import Foundation

class Debouncer {
    private static var workItems: [String: DispatchWorkItem] = [:]
    
    static func debounce(identifier: String, delay: TimeInterval = 0.1, action: @escaping () -> Void) {
        // Cancel existing work item for this identifier
        workItems[identifier]?.cancel()
        
        // Create new work item
        let workItem = DispatchWorkItem(block: action)
        workItems[identifier] = workItem
        
        // Execute after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
    
    static func cancel(identifier: String) {
        workItems[identifier]?.cancel()
        workItems.removeValue(forKey: identifier)
    }
    
    static func cancelAll() {
        workItems.values.forEach { $0.cancel() }
        workItems.removeAll()
    }
}
