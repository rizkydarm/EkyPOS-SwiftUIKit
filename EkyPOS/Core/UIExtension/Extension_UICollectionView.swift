//
//  Extension_UICollectionView.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let identifier = "\(cellClass)"
        let nib = UINib(nibName: identifier, bundle: Bundle(for: cellClass))
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func registerCell<T: UICollectionViewCell>(cell name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = "\(cellClass)"
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error dequeueing cell")
        }
        return cell
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error for cell if: \(identifier) at \(indexPath)")
        }
        return cell
    }
}
