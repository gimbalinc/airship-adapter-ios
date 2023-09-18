//
//  BaseTableViewCell.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 6/9/22.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
