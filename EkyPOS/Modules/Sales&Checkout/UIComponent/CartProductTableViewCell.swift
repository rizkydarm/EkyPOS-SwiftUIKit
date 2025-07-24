
import UIKit
import Combine
import SnapKit

class CartProductTableViewCell: UITableViewCell {
    
    private var cartProduct: CartProductModel?

    private let cartViewModel = CartViewModel.shared
    private var cancellables = Set<AnyCancellable>()

    private let emoji: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
        
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()        

    private let incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()

    private let unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let decrementButton: UIButton = {
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

        cartViewModel.cartProductsPublisher
            .receive(on: RunLoop.main)
            .map { cartProducts in
                cartProducts.first { $0.product == self.cartProduct?.product }?.total ?? 0
            }
            .removeDuplicates()
            .sink { [weak self] total in
                self?.unitLabel.text = String(total)
                self?.decrementButton.isEnabled = total > 1
            }
            .store(in: &cancellables)
        
        decrementButton.addAction(UIAction { [weak self] _ in
            guard let cartProduct = self?.cartProduct else { return }
            self?.cartViewModel.decrementQuantity(for: cartProduct.product)
        }, for: .touchUpInside)
        
        incrementButton.addAction(UIAction { [weak self] _ in
            guard let cartProduct = self?.cartProduct else { return }
            self?.cartViewModel.incrementQuantity(for: cartProduct.product)
        }, for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        cartProduct = nil
    }
}
