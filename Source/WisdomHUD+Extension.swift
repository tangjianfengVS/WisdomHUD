//
//  WisdomHUD+Extension.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

//TODO: Extension UIView
extension UIView {
    
    // MARK: - set layout size
    @objc public func wisdom_addConstraint(width: CGFloat, height: CGFloat) {
        if width > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: width))
        }
        if height > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: height))
        }
    }
    
    // MARK: - set layout center
    @objc public func wisdom_addConstraint(toCenterX xView: UIView?, toCenterY yView: UIView?) {
        wisdom_addConstraint(toCenterX: xView, constantx: 0, toCenterY: yView, constanty: 0)
    }
    
    // MARK: - set layout center offset
    @objc public func wisdom_addConstraint(toCenterX xView: UIView?,
                                                 constantx: CGFloat,
                                           toCenterY yView: UIView?,
                                                 constanty: CGFloat) {
        if let xView = xView {
            addConstraint(NSLayoutConstraint(item: xView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: constantx))
        }
        if let yView = yView {
            addConstraint(NSLayoutConstraint(item: yView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: constanty))
        }
    }
    
    // MARK: - set layout edage inset
    @objc public func wisdom_addConstraint(to view: UIView, edageInset: UIEdgeInsets) {
        wisdom_addConstraint(with: view,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: edageInset)
    }
    
    // MARK: - set layout edage inset to UIView
    @objc public func wisdom_addConstraint(with view: UIView,
                                             topView: UIView?,
                                            leftView: UIView?,
                                          bottomView: UIView?,
                                           rightView: UIView?,
                                           edgeInset: UIEdgeInsets) {
        if let topView = topView {
            let topConstraint = NSLayoutConstraint(item: view,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: topView,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: edgeInset.top)
            topConstraint.identifier = WisdomHUDOperate.getWisdom_Focusing()
            addConstraint(topConstraint)
        }
        if let leftView = leftView {
            let leftConstraint = NSLayoutConstraint(item: view,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: leftView,
                                                    attribute: .left,
                                                    multiplier: 1.0,
                                                    constant: edgeInset.left)
            leftConstraint.identifier = WisdomHUDOperate.getWisdom_Focusing()
            addConstraint(leftConstraint)
        }
        if let bottomView = bottomView {
            let bottomConstraint = NSLayoutConstraint(item: view,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: bottomView,
                                                      attribute: .bottom,
                                                      multiplier: 1.0,
                                                      constant: edgeInset.bottom)
            bottomConstraint.identifier = WisdomHUDOperate.getWisdom_Focusing()
            addConstraint(bottomConstraint)
        }
        if let rightView = rightView {
            let rightConstraint = NSLayoutConstraint(item: view,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: rightView,
                                                     attribute: .right,
                                                     multiplier: 1.0,
                                                     constant: edgeInset.right)
            rightConstraint.identifier = WisdomHUDOperate.getWisdom_Focusing()
            addConstraint(rightConstraint)
        }
    }
}


extension String {
    
    // MARK: - Get Text Size With: UIFont - CGSize
    public func wisdom_textSize(font: UIFont, constrainedToSize size: CGSize) -> CGSize {
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
            textSize = self.size(withAttributes: attributes as? [NSAttributedString.Key : Any] )
            
        } else {
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
            
            let stringRect = self.boundingRect(with: size,
                                               options: option,
                                               attributes: attributes as? [NSAttributedString.Key : Any],
                                               context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}


extension UIColor {
    
    // MARK: - Get Color with: String
    @objc public static func wisdom_colorHex(hex: String, alpha: CGFloat=1) -> UIColor {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
            
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
            
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return UIColor(red:CGFloat(r)/0xff, green:CGFloat(g)/0xff, blue:CGFloat(b)/0xff, alpha:alpha)
    }
}

