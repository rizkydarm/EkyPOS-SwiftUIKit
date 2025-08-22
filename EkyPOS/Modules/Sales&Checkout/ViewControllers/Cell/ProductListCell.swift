

import UIKit
import IGListKit

class ProductListCell: RippleCollectionViewCell, ListBindable { 
    
    lazy private var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .label
        view.font = .systemFont(ofSize: 16, weight: .bold)
        return view
    }()

    lazy private var emojiLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .label
        view.font = .systemFont(ofSize: 32, weight: .bold)
        return view
    }()

    lazy private var priceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()

    lazy private var categoryLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()

    lazy private var checkmarkImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(config))
        checkmark.tintColor = .systemGreen
        checkmark.isHidden = true
        return checkmark
    }()

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ProductModel else { return }

        nameLabel.text = viewModel.name
        emojiLabel.text = viewModel.image.containsEmoji ? viewModel.image : "🟤"
        priceLabel.text = rpCurrencyFormatter.string(from: viewModel.price as NSNumber)
        categoryLabel.text = viewModel.category?.name ?? "-"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(nameLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(checkmarkImageView)

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true

        emojiLabel.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.left.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(emojiLabel.snp.right).offset(20)
            make.right.lessThanOrEqualTo(categoryLabel.snp.left).offset(-10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(emojiLabel.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }

        categoryLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
        }

        checkmarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelected(_ isSelected: Bool) {
        self.backgroundColor = isSelected ? UIColor.systemGreen.withAlphaComponent(0.2) : .secondarySystemBackground
        self.checkmarkImageView.alpha = isSelected ? 1.0 : 0.0
        self.checkmarkImageView.isHidden = isSelected ? false : true
        self.checkmarkImageView.transform = isSelected ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
}