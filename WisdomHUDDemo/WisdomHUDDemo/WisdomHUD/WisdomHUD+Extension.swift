//
//  WisdomHUD+Extension.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

//TODO: Extension UIView
extension UIView {
    
    func animate(hide:Bool, completion:(() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
                self.alpha = 0
            }else {
                self.alpha = 1
            }
        }) { _ in
            completion?()
        }
    }
    
    func addConstraint(width: CGFloat,height:CGFloat) {
        if width > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: NSLayoutConstraint.Attribute(rawValue: 0)!,
                                             multiplier: 1,
                                             constant: width))
        }
        if height > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: NSLayoutConstraint.Attribute(rawValue: 0)!,
                                             multiplier: 1,
                                             constant: height))
        }
    }
    
    func addConstraint(toCenterX xView:UIView?,toCenterY yView:UIView?) {
        addConstraint(toCenterX: xView, constantx: 0, toCenterY: yView, constanty: 0)
    }
    
    func addConstraint(toCenterX xView:UIView?,
                       constantx:CGFloat,
                       toCenterY yView:UIView?,
                       constanty:CGFloat) {
        if let xView = xView {
            addConstraint(NSLayoutConstraint(item: xView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerX,
                                             multiplier: 1, constant: constantx))
        }
        if let yView = yView {
            addConstraint(NSLayoutConstraint(item: yView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: constanty))
        }
    }
    
    func addConstraint(to view:UIView,edageInset:UIEdgeInsets) {
        addConstraint(with: view,
                      topView: self,
                      leftView: self,
                      bottomView: self,
                      rightView: self,
                      edgeInset: edageInset)
    }
    
    func addConstraint(with view:UIView,
                                   topView:UIView?,
                                   leftView:UIView?,
                                   bottomView:UIView?,
                                   rightView:UIView?,
                                   edgeInset:UIEdgeInsets) {
        if let topView = topView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: topView,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: edgeInset.top))
        }
        if let leftView = leftView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .left,
                                             relatedBy: .equal,
                                             toItem: leftView,
                                             attribute: .left,
                                             multiplier: 1,
                                             constant: edgeInset.left))
        }
        if let bottomView = bottomView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: bottomView,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: edgeInset.bottom))
        }
        if let rightView = rightView {
            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .right,
                                             relatedBy: .equal,
                                             toItem: rightView,
                                             attribute: .right,
                                             multiplier: 1,
                                             constant: edgeInset.right))
        }
    }
}


extension String {
    
    /** 计算String内容的大小
     *  font： 文字字号大小
     *  size： 内容大小限定
     */
    func textSizeWithFont(font: UIFont, constrainedToSize size: CGSize) -> CGSize {
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
