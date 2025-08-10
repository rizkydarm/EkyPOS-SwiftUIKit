//
//  RowStack.swift
//  EkyPOS
//
//  Created by Eky on 23/07/25.
//

import UIKit

class LabelRowStack: UIView {
    
    let row = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        row.axis = .horizontal
        row.distribution = .fill
        row.alignment = .center
        row.spacing = 8

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        row.addArrangedSubview(spacer)
        
        addSubview(row)
        row.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setLeftLabel(leftLabel: UILabel) {
        row.insertArrangedSubview(leftLabel, at: 0)
    }

    func setRightLabel(rightLabel: UILabel) {
        row.insertArrangedSubview(rightLabel, at: row.arrangedSubviews.count)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}