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
