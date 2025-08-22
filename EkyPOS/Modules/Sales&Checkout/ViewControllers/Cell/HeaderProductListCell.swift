import UIKit

class HeaderProductListCell: UICollectionViewCell {
    
    lazy private var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = .label
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 12, weight: .regular)
        return view
    }()

    lazy private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
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

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)

        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(20)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}