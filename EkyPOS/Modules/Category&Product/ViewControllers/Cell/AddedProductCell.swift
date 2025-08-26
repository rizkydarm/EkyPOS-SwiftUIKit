import UIKit

class AddedProductCell: UITableViewCell {
        
    private lazy var emoji: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    func configure(with product: ProductModel) {
        emoji.text = product.image.containsEmoji ? product.image : "🟤"
        label.text = product.name
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(emoji.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}