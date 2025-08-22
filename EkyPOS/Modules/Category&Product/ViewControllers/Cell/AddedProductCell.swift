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
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)

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


extension AddedProductCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let previewVC = FocusPreviewViewController()
                return previewVC
            },
            actionProvider: { suggestedActions in
                let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                    
                }
                let save = UIAction(title: "Save", image: UIImage(systemName: "bookmark")) { action in
                    
                }
                let add = UIAction(title: "Add", image: UIImage(systemName: "plus.circle.fill")) { action in
                    
                }
                let favorite = UIAction(title: "Favorite", image: UIImage(systemName: "heart.fill")) { action in
                    
                }
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill")) { action in
                    
                }
                return UIMenu(title: "Menu", children: [share, save, add, favorite, delete])
            }
        )
    }
}

class FocusPreviewViewController: UIViewController {
    
    public var product: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let imageView = UIImageView(image: UIImage(named: ""))
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }
    }
}