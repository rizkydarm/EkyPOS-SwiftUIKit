//
//  Extension_UITableView.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        let identifier = "\(cell)"
        register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        let identifier = "\(cell)"
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error dequeueing cell")
        }
        return cell
    }
}
