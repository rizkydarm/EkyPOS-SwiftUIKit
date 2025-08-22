
import UIKit
import Combine
import SnapKit

class CartProductTableViewCell: UITableViewCell {
    
    private var cartProduct: CartProductModel?

    private var cancellables = Set<AnyCancellable>()

    private let cartCellViewModel = CartCellViewModel()
    private let cartViewModel = CartViewModel.shared

    private lazy var emoji: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
        
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()        

    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()

    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    func configure(with cartProduct: CartProductModel) {
        self.cartProduct = cartProduct

        emoji.text = cartProduct.product.image.containsEmoji ? cartProduct.product.image : "🟤"
        contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        title.text = cartProduct.product.name
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(emoji.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }

        subtitle.text = rpCurrencyFormatter.string(from: cartProduct.product.price as NSNumber)
        contentView.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.left.equalTo(title.snp.right).offset(10)
            make.centerY.equalToSuperview()
        } 

        contentView.addSubview(incrementButton)
        incrementButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        unitLabel.text = String(cartProduct.total)
        contentView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.right.equalTo(incrementButton.snp.left).offset(-20)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(decrementButton)
        decrementButton.snp.makeConstraints { make in
            make.right.equalTo(unitLabel.snp.left).offset(-20)
            make.centerY.equalToSuperview()
        }
        decrementButton.isEnabled = cartProduct.total > 1
        
        decrementButton.addAction(UIAction { [weak self] _ in
            Debouncer.debounce(identifier: "decrementQuantity_\(self.hashValue)", action: {
                self?.cartCellViewModel.decrementQuantity()
                self?.cartViewModel.decrementQuantity(for: cartProduct.product)
            })
        }, for: .touchUpInside)
        
        incrementButton.addAction(UIAction { [weak self] _ in
            Debouncer.debounce(identifier: "incrementQuantity_\(self.hashValue)", action: {
                self?.cartCellViewModel.incrementQuantity()
                self?.cartViewModel.incrementQuantity(for: cartProduct.product)
            })
        }, for: .touchUpInside)

        setupBindings()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) { fatalError() }


    private func setupBindings() {
        cartCellViewModel.number = cartProduct?.total ?? 0
        cartCellViewModel.$number
            .receive(on: RunLoop.main)
            .sink { [weak self] total in
                self?.unitLabel.text = String(total)
                self?.cartProduct?.total = total
                self?.decrementButton.isEnabled = total > 1
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        cartProduct = nil
        cartCellViewModel.number = 0
    }
}

class CartCellViewModel {
    @Published var number: Int = 0

    func incrementQuantity() {
        number += 1
    }
    
    func decrementQuantity() {
        if number > 1 {
            number -= 1
        }
    }
}

