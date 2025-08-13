

import UIKit

class ProductListCell: UICollectionViewCell {
    
    lazy private var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .label
        view.font = .systemFont(ofSize: 16, weight: .bold)
        return view
    }()

    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }

    lazy private var emojiLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .label
        view.font = .systemFont(ofSize: 32, weight: .bold)
        return view
    }()

    var emoji: String? {
        get {
            return emojiLabel.text
        }
        set {
            emojiLabel.text = (newValue?.containsEmoji ?? false) ? newValue : "🟤"
        }
    }

    lazy private var priceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()

    var price: String? {
        get {
            return priceLabel.text
        }
        set {
            priceLabel.text = newValue
        }
    }

    lazy private var categoryLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()

    var category: String? {
        get {
            return categoryLabel.text
        }
        set {
            categoryLabel.text = newValue
        }
    }

    lazy private var checkmarkImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(config))
        checkmark.tintColor = .systemGreen
        checkmark.isHidden = true
        return checkmark
    }()

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
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(emojiLabel.snp.right).inset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
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
        // Determine the final background color
        let finalBackgroundColor: UIColor = isSelected ? UIColor.systemGreen.withAlphaComponent(0.2) : .secondarySystemBackground

        // Perform the animation
        UIView.animate(withDuration: 0.15, // Short duration for snappy feel
                       delay: 0,
                       options: [.curveEaseInOut], // Standard easing
                       animations: {
            // Animate background color change
            self.backgroundColor = finalBackgroundColor

            // Animate checkmark appearance/disappearance
            self.checkmarkImageView.alpha = isSelected ? 0.0 : 1.0 // Start opposite for fade effect
            self.checkmarkImageView.isHidden = false // Unhide it for animation
            self.checkmarkImageView.transform = isSelected ? CGAffineTransform(scaleX: 0.1, y: 0.1) : CGAffineTransform.identity // Start small if selecting

            // Trigger the animations
            self.checkmarkImageView.alpha = isSelected ? 1.0 : 0.0 // Animate to final alpha
            self.checkmarkImageView.transform = isSelected ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.1, y: 0.1) // Animate to final scale
        }) { _ in
            // Completion block
            // Ensure final state is correct, especially hiding the checkmark if deselected
            if !isSelected {
                 // Delay hiding slightly to ensure animation finishes, or check alpha
                 // A more robust check might be needed depending on exact visual needs
                 // For simplicity, we'll just set hidden based on isSelected at the end
                 // However, the alpha animation already fades it out.
                 // Let's just ensure it's hidden if not selected at the end.
                 // The transform scaling down + alpha 0 usually achieves the "disappearance"
                 // But explicitly hiding ensures it doesn't take up visual space if layout depends on it.
                 // Given the layout constraints, hiding might be cleaner.
                 // Let's revise the animation slightly for clarity:

            }
             // Ensure final visibility state
             self.checkmarkImageView.isHidden = !isSelected
             // Ensure final transform is identity if selected, or scaled down if not
             // The completion block ensures final state even if interrupted
             self.checkmarkImageView.transform = isSelected ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.01, y: 0.01) // Nearly invisible scale
             // Reset alpha in case it got stuck
             self.checkmarkImageView.alpha = isSelected ? 1.0 : 0.0

        }
    }

}
