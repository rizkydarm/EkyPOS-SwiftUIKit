//
//  CategoryProductViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit


class CategoryViewController: UIViewController {
    
    private let categoryRepo = CategoryRepo()
    private var categories: [CategoryModel] = []
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Category & Product"
        view.backgroundColor = .systemBackground
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                self?.sideMenuController?.revealMenu()
            }
        )
        navigationItem.leftBarButtonItem = menuButton
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill")?.withConfiguration(config),
            primaryAction: UIAction { [weak self] _ in
                guard let self = self else { return }
                let vc = AddCategoryViewController()
                vc.didInputComplete = { [weak self] (text, image) in
                    guard let self = self else { return }
                    self.categoryRepo.addCategory(name: text, image: image)
                    self.loadCategories()
                }
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
            }
        )
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = .systemBrown
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadCategories()
    }
    
    private func loadCategories() {
        categories = categoryRepo.getAllCategories()
        tableView.reloadData()
    }

}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .systemBackground
        
        let category = categories[indexPath.row]
        
        let emoji = UILabel()
        emoji.textColor = .label
        emoji.font = .systemFont(ofSize: 24, weight: .bold)
        emoji.text = category.image.containsEmoji ? category.image : "🟤"
        cell.contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = category.name
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(emoji.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCategory = categories[indexPath.row]
        navigationController?.pushViewController(ProductViewController(category: selectedCategory), animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                    
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            self.deleteCategory(at: indexPath)
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let vc = AddCategoryViewController()
            let selectedCategory = categories[indexPath.row]
            vc.editingMode = (selectedCategory.name, selectedCategory.image)
            vc.didInputComplete = { [weak self] (text, image) in
                guard let self = self else { return }
                self.editCategory(at: indexPath, newName: text, newImage: image)
                self.loadCategories()
            }
            self.present(vc, animated: true)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func deleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        categoryRepo.deleteCategory(id: category._id)
        categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    private func editCategory(at indexPath: IndexPath, newName: String, newImage: String?) {
        let category = categories[indexPath.row]
        categoryRepo.updateCategory(id: category._id, newName: newName, newImage: newImage)
        categories.remove(at: indexPath.row)
    }
}

