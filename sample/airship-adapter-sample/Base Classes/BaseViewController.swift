//
//  BaseViewController.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 5/18/22.
//

import Foundation
import UIKit

class BaseViewController<V: UIView>: UIViewController {
    var mainView = V()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(mainView)
        
        if #available(iOS 13.0, *) {
            mainView.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.safeAreaLayoutGuide.leadingAnchor,
                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                trailing: view.safeAreaLayoutGuide.trailingAnchor,
                centerX: view.safeAreaLayoutGuide.centerXAnchor,
                centerY: view.safeAreaLayoutGuide.centerYAnchor
            )
        } else {
            mainView.anchor(
                top: view.topAnchor,
                leading: view.leadingAnchor,
                bottom: view.bottomAnchor,
                trailing: view.trailingAnchor,
                centerX: view.centerXAnchor,
                centerY: view.centerYAnchor
            )
        }
    }
}
