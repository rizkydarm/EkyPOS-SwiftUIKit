//
//  Extension_Date.swift
//  EkyPOS
//
//  Created by Eky on 25/07/25.
//

import Foundation

extension Date {
    func formattedTimeOnly() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h.mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: self)
    }
}

extension Date {
    
    // MARK: - Convert Date to ISO 8601 String
    /// Converts Date to ISO 8601 format: "2025-08-08T10:46:56.000Z"
    func toISOString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
    
    /// Alternative method using DateFormatter
    func toISOStringAlternative() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    /// Custom format method for specific format
    func toCustomISOFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}


