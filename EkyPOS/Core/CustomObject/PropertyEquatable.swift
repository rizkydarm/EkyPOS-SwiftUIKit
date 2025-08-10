import Foundation

protocol PropertyEquatable: Equatable {
    /// Return an array of properties to be used for equality comparison
    /// - Returns: Array of Any representing the properties to compare
    func equalityProperties() -> [Any]
}

// MARK: - Default Implementation
extension PropertyEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        let leftProperties = lhs.equalityProperties()
        let rightProperties = rhs.equalityProperties()
        
        // Check if both arrays have the same count
        guard leftProperties.count == rightProperties.count else {
            return false
        }
        
        // Compare each property
        for (left, right) in zip(leftProperties, rightProperties) {
            if !areEqual(left, right) {
                return false
            }
        }
        
        return true
    }
    
    /// Helper function to compare two Any values
    private static func areEqual(_ lhs: Any, _ rhs: Any) -> Bool {
        // Handle NSObject types
        if let lhsNSObject = lhs as? NSObject,
           let rhsNSObject = rhs as? NSObject {
            return lhsNSObject.isEqual(rhsNSObject)
        }
        
        // Handle common types that conform to Equatable
        switch (lhs, rhs) {
        case let (left as String, right as String):
            return left == right
        case let (left as Int, right as Int):
            return left == right
        case let (left as Double, right as Double):
            return left == right
        case let (left as Float, right as Float):
            return left == right
        case let (left as Bool, right as Bool):
            return left == right
        case let (left as Int8, right as Int8):
            return left == right
        case let (left as Int16, right as Int16):
            return left == right
        case let (left as Int32, right as Int32):
            return left == right
        case let (left as Int64, right as Int64):
            return left == right
        case let (left as UInt, right as UInt):
            return left == right
        case let (left as UInt8, right as UInt8):
            return left == right
        case let (left as UInt16, right as UInt16):
            return left == right
        case let (left as UInt32, right as UInt32):
            return left == right
        case let (left as UInt64, right as UInt64):
            return left == right
        case let (left as Array<Any>, right as Array<Any>):
            return left.count == right.count && 
                   zip(left, right).allSatisfy { areEqual($0, $1) }
        case let (left as Dictionary<AnyHashable, Any>, right as Dictionary<AnyHashable, Any>):
            return left.count == right.count &&
                   left.allSatisfy { key, value in
                       guard let rightValue = right[key] else { return false }
                       return areEqual(value, rightValue)
                   }
        case let (left as Optional<Any>, right as Optional<Any>):
            switch (left, right) {
            case (nil, nil):
                return true
            case (let l?, let r?):
                return areEqual(l, r)
            default:
                return false
            }
        default:
            // For custom types, try to compare using NSObject's isEqual if possible
            if let leftNSObject = lhs as? NSObject,
               let rightNSObject = rhs as? NSObject {
                return leftNSObject.isEqual(rightNSObject)
            }
            // Fallback: compare string representations (not ideal, but better than nothing)
            return String(describing: lhs) == String(describing: rhs)
        }
    }
}