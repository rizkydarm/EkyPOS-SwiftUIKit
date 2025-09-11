import UIKit

final class CategoryOptionViewController: UIViewController {

    public var selectedCategories = Set<CategoryModel>()
    public var unSelectedCategories = Set<CategoryModel>()
    public var availableCategories: [CategoryModel] = []

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        return view
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change", for: .normal)
        button.backgroundColor = .accent
        button.tintColor = .label
        button.layer.cornerRadius = 8
        button.enableBounceAnimation()
        return button
    }()

    public var didChangeCategory: ((Set<CategoryModel>, Set<CategoryModel>) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        view.addSubview(doneButton)

        doneButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.unSelectedCategories = Set(self.availableCategories.filter { !self.selectedCategories.contains($0) })
            self.didChangeCategory?(self.selectedCategories, self.unSelectedCategories)
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.72)
        }

        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
    }

}

extension CategoryOptionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        availableCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = availableCategories[indexPath.row].name
        cell.accessoryType = toggleSelection(at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = toggleSelection(at: indexPath)
        // dismiss(animated: true)
    }

    func toggleSelection(at indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        if (!selectedCategories.contains(availableCategories[indexPath.row])) {
            selectedCategories.insert(availableCategories[indexPath.row])
            return .checkmark
        } else {
            selectedCategories.remove(availableCategories[indexPath.row])
            return .none
        }
    }
}