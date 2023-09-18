//
//  LabelCell.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 6/9/22.
//

import Foundation
import UIKit

class LabelCell: BaseTableViewCell {
    let firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.add(subviews: [self.firstLabel, self.secondLabel])
        
        self.firstLabel.anchor(
            top: self.contentView.topAnchor,
            leading: self.contentView.leadingAnchor,
            bottom: nil,
            trailing: self.contentView.trailingAnchor,
            padding: .init(top: 0, left: 20, bottom: 0, right: 20),
            centerX: nil,
            centerY: nil
        )
        self.secondLabel.anchor(
            top: self.firstLabel.bottomAnchor,
            leading: self.contentView.leadingAnchor,
            bottom: self.contentView.bottomAnchor,
            trailing: self.contentView.trailingAnchor,
            padding: .init(top: 0, left: 20, bottom: 0, right: 20),
            centerX: nil,
            centerY: nil
        )
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
