//
//  ViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import SnapKit

class SalesViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()
    
    private var items = Array(1...20).map { "Item \($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sales"
        view.backgroundColor = .systemBackground
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                self?.sideMenuController?.revealMenu()
            }
        )
        navigationItem.leftBarButtonItem = menuButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true

        navigationItem.hidesSearchBarWhenScrolling = true

        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .label
        
        navigationItem.searchController = searchController
        
//        tableView.decelerationRate = .normal
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension SalesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = items[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = item

        config.secondaryText = "Subtitle for \(item)"
        config.secondaryTextProperties.font = .systemFont(ofSize: 14)
        config.secondaryTextProperties.color = .secondaryLabel
        
        cell.contentConfiguration = config
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: imageConfig))
        
        cell.backgroundColor = .quaternarySystemFill
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension SalesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            items = Array(1...20).map { "Item \($0)" }
            tableView.reloadData()
            return
        }
        items = Array(1...20).map { "Item \($0)" }.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

extension SalesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let leftButton = self.navigationItem.leftBarButtonItem else {
            return
        }
        let isScrollingDown = scrollView.contentOffset.y > -90
        if isScrollingDown {
            leftButton.tintColor = .label
        } else {
            leftButton.tintColor = .systemBrown
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 17.0, *)
#Preview("SalesViewController (iOS 17+)") {
    SalesViewController()
}
@available(iOS 13.0, *)
struct SalesViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SalesViewController()
        }
        .previewDisplayName("SalesViewController (Legacy)")
    }
}
#endif
