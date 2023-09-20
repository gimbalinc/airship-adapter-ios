//
//  EventsView.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 6/9/22.
//

import Foundation
import UIKit

class EventsView: UIView {
    private let header: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "All Received Events"
        label.textColor = .gimbalOrange
        label.font = UIFont.brandonBold(ofSize: 20.0)
        return label
    }()
    
    let eventsTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.add(subviews: [header, eventsTable])
        
        header.anchor(
            top: topAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil,
            size: .init(width: 0, height: 80),
            centerX: centerXAnchor,
            centerY: nil
        )
        eventsTable.anchor(
            top: header.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 8, right: 0),
            centerX: nil,
            centerY: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
