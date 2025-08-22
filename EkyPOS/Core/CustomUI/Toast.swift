//
//  Toast.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import UIKit
import AwaitToast

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


func showToast(_ type: ToastType, title: String, message: String, seconds: Double = 3) {

    // let defaultAppearance = ToastAppearanceManager.default
    let iconAppearance = ToastAppearanceManager.icon

    // defaultAppearance.height = 200
    // defaultAppearance.numberOfLines = 2
    // defaultAppearance.textAlignment = .left
    // defaultAppearance.textColor = .label

    iconAppearance.height = 80
    iconAppearance.numberOfLines = 2
    iconAppearance.textAlignment = .left
    iconAppearance.imageTintColor = .label
    iconAppearance.textColor = .label
    iconAppearance.backgroundColor = type.color

    let defaultBehavior = ToastBehaviorManager.default

    defaultBehavior.isTappedDismissEnabled = true
    defaultBehavior.delay = seconds
    defaultBehavior.showDurarion = 0.3
    defaultBehavior.duration = seconds
    defaultBehavior.dismissDuration = 0.3
    
    let toast = Toast.icon(image: type.icon ?? UIImage(), imageLocation: .left, attributedString: NSAttributedString(string: title+"\n"+message), direction: .bottom)
    
    toast.show()

    // toast.dismiss()
}

