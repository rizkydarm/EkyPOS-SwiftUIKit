
import IGListKit
import UIKit

final class ProductSectionController: ListSectionController {

    public var product: ProductModel?
    private let isReorderable: Bool

    required init(isReorderable: Bool = false) {
        self.isReorderable = isReorderable
        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
    }

    override func numberOfItems() -> Int {
        return 5
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {

        let cell: UICollectionViewCell = UICollectionViewCell()
        cell.backgroundColor = .systemBackground

        guard let product = product else { return cell }
        
        // cell.backgroundColor = selectedProducts.contains(product) ? .secondarySystemFill : .secondarySystemBackground
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true

        let emoji = UILabel()
        emoji.textColor = .label
        emoji.font = .systemFont(ofSize: 24, weight: .bold)
        emoji.text = product.image.containsEmoji ? product.image : "🟤"
        cell.contentView.addSubview(emoji)
        emoji.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
        }
        
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = product.name
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(emoji.snp.bottom).offset(20)
        }
        
        let subLabel = UILabel()
        subLabel.textColor = .secondaryLabel
        subLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subLabel.text = rpCurrencyFormatter.string(from: product.price as NSNumber)
        cell.contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(label.snp.bottom).offset(20)
        }

        // let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        // let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(config))
        // checkmark.tintColor = .systemGreen
        // checkmark.isHidden = !selectedProducts.contains(product)
        // cell.contentView.addSubview(checkmark)
        // checkmark.snp.makeConstraints { make in
        //     make.right.equalToSuperview().inset(20)
        //     make.top.equalTo(subLabel.snp.bottom).offset(20)
        //     make.width.height.equalTo(30)
        // }

        let categoryLabel = UILabel()
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        categoryLabel.text = product.category?.name ?? "-"
        cell.contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        self.product = object as? ProductModel
    }

}
