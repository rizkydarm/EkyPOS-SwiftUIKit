//
//  Toast.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import UIKit

enum ToastType {
    case info
    case error
    case warning
    case success
    
    var title: String {
        switch self {
        case .info: return "Info"
        case .error: return "Error"
        case .warning: return "Warning"
        case .success: return "Success"
        }
    }

    
    var icon: UIImage? {
        switch self {
        case .info: return UIImage(systemName: "info.circle")
        case .error: return UIImage(systemName: "xmark.circle")
        case .warning: return UIImage(systemName: "exclamationmark.triangle")
        case .success: return UIImage(systemName: "checkmark.circle")
        }
    }
    
    var color: UIColor {
        switch self {
        case .info: return .systemYellow
        case .error: return .systemRed
        case .warning: return .systemOrange
        case .success: return .systemGreen
        }
    }
}

func showToast(_ type: ToastType, vc: UIViewController, message: String, seconds: Double = 3) {
    let alert: UIAlertController = UIAlertController(title: type.title, message: message, preferredStyle: .alert)
    
    // alert.view.backgroundColor = type.color
    // alert.view.layer.cornerRadius = 16
    // alert.view.layer.masksToBounds = true
    
    vc.present(alert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        alert.dismiss(animated: true)
    }
}
