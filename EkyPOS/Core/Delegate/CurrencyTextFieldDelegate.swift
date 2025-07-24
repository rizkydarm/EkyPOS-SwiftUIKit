//
//  CurrencyTextFieldDelegate.swift
//  EkyPOS
//
//  Created by Eky on 24/07/25.
//

import UIKit

class CurrencyTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var values: [UITextField: Double] = [:]
    
    func getRawValue(for textField: UITextField) -> Double {
        // Always return the current parsed value
        return parseCurrencyText(textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        updateTextField(textField, with: replacementText)
        
        return false
    }
    
    // Helper method to update text field with formatted currency
    private func updateTextField(_ textField: UITextField, with text: String) {
        let value = parseCurrencyText(text)
        textField.text = formatCurrency(value)
        values[textField] = value
    }
    
    // Helper method to parse currency text to Double
    private func parseCurrencyText(_ text: String) -> Double {
        let cleanString = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Double(cleanString) ?? 0
    }
    
    // Helper method to format Double as currency
    private func formatCurrency(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp" // Or your preferred currency symbol
        formatter.maximumFractionDigits = 0 // Adjust as needed
        return formatter.string(from: NSNumber(value: value))
    }
    
    // Handle cases where text is set programmatically
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateTextField(textField, with: textField.text ?? "")
    }
}
