

import UIKit
import IGListKit

class ProductListCell: RippleCollectionViewCell, ListBindable { 
    
    lazy private var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .label
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.preferredMaxLayoutWidth = 200
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

    lazy private var stockLabel: UILabel = {
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

    var product: ProductModel?

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ProductModel else { return }

        product = viewModel

        nameLabel.text = viewModel.name
        emojiLabel.text = viewModel.image.containsEmoji ? viewModel.image : "🟤"
        priceLabel.text = rpCurrencyFormatter.string(from: viewModel.price as NSNumber)
        stockLabel.text = "\(viewModel.stock) left"
        categoryLabel.text = viewModel.category?.name ?? "-"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)

        contentView.addSubview(nameLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
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
            make.right.lessThanOrEqualTo(stockLabel.snp.left).offset(-10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(emojiLabel.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }

        stockLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(20)
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

extension ProductListCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let previewVC: FocusPreviewViewController = FocusPreviewViewController()
                previewVC.product = self.product
                return previewVC
            },
            actionProvider: { suggestedActions in
                let share = UIAction(title: "Restock", image: UIImage(systemName: "arrow.2.circlepath")) { action in
                    
                }
                // let save = UIAction(title: "Save", image: UIImage(systemName: "bookmark")) { action in
                    
                // }
                // let add = UIAction(title: "Add", image: UIImage(systemName: "plus.circle.fill")) { action in
                    
                // }
                // let favorite = UIAction(title: "Favorite", image: UIImage(systemName: "heart.fill")) { action in
                    
                // }
                // let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill")) { action in
                    
                // }
                return UIMenu(children: [share])
            }
        )
    }
}

class FocusPreviewViewController: UIViewController {
    
    public var product: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let emojiLabel = UILabel()
        emojiLabel.text = (product?.image.containsEmoji ?? false) ? product?.image : "🟤"
        emojiLabel.font = .systemFont(ofSize: 100, weight: .bold)
        emojiLabel.contentMode = .scaleAspectFit
        emojiLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        emojiLabel.textAlignment = .center
        view.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }
    }
}