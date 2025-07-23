//
//  Currency.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import Foundation

let rpCurrencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "Rp"
    formatter.maximumFractionDigits = 0
    formatter.locale = Locale(identifier: "id_ID") // Indonesian locale
    return formatter
}()
