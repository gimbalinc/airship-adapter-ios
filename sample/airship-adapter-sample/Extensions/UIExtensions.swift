//
//  UIExtensions.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 5/18/22.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    @discardableResult func appendText(_ text: String, font: UIFont, color: UIColor? = nil, alignment: NSTextAlignment? = nil)
    -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [.font : font]
        if let color = color {
            attributes[.foregroundColor] = color
        }
        if let alignment = alignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        let newText = NSAttributedString(string: text, attributes: attributes)
        append(newText)
        
        return self
    }
}

extension UIColor {
    class var gimbalDarkBlue: UIColor {
        return UIColor(red: 37/255, green: 49/255, blue: 59/255, alpha: 1)
    }
    
    class var gimbalOrange: UIColor {
        return UIColor(red: 249/255, green: 102/255, blue: 85/255, alpha: 1)
    }
    
    class var gimbalLightBlue: UIColor {
        return UIColor(red: 100/255, green: 228/255, blue: 210/255, alpha: 1)
    }
    
    class var gimbalGray: UIColor {
        return UIColor(red: 103/255, green: 125/255, blue: 128/255, alpha: 1)
    }
}

extension UIFont {
    class func brandonLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonText-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func brandonRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonText-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func brandonMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonText-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func brandonBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "BrandonText-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UIView {
    func add(subviews: [UIView]) {
        for view in subviews {
            self.addSubview(view)
        }
    }
    
    struct AnchoredConstraints {
        var top,
            leading,
            bottom,
            trailing,
            width,
            height,
            centerX,
            centerY: NSLayoutConstraint?
    }
    
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor?,
        leading: NSLayoutXAxisAnchor?,
        bottom: NSLayoutYAxisAnchor?,
        trailing: NSLayoutXAxisAnchor?,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero,
        centerX: NSLayoutXAxisAnchor?,
        centerY: NSLayoutYAxisAnchor?,
        centerXOffset: CGFloat = 0,
        centerYOffset: CGFloat = 0
    ) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(
                equalTo: top,
                constant: padding.top
            )
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(
                equalTo: leading,
                constant: padding.left
            )
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(
                equalTo: bottom,
                constant: -padding.bottom
            )
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(
                equalTo: trailing,
                constant: -padding.right
            )
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(
                equalToConstant: size.width
            )
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(
                equalToConstant: size.height
            )
        }
        
        if let centerX = centerX {
            anchoredConstraints.centerX = centerXAnchor.constraint(
                equalTo: centerX,
                constant: centerXOffset
            )
        }
        
        if let centerY = centerY {
            anchoredConstraints.centerY = centerYAnchor.constraint(
                equalTo: centerY,
                constant: centerYOffset
            )
        }
        
        [
            anchoredConstraints.top,
            anchoredConstraints.leading,
            anchoredConstraints.bottom,
            anchoredConstraints.trailing,
            anchoredConstraints.width,
            anchoredConstraints.height,
            anchoredConstraints.centerX,
            anchoredConstraints.centerY
        ].forEach {
            $0?.isActive = true
        }
      
        return anchoredConstraints
    }
}
