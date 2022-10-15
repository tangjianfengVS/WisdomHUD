//
//  WisdomHUDIconView.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit


final class WisdomHUDIconView: UIView {
    
    private var iconView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomHUDIconView: WisdomHUDSetIconable {
    
    func setLoadingIcon(size: CGFloat, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle) {
        iconView?.removeFromSuperview()
        
        switch loadingStyle {
        case .rotate:
            iconView = WisdomHUDRotateView(size: size, barStyle: barStyle)
            addSubview(iconView!)
            
            wisdom_addConstraint(with: iconView!,
                              topView: self,
                             leftView: self,
                           bottomView: self,
                            rightView: self,
                            edgeInset: UIEdgeInsets.zero)
        case .system:
            iconView = WisdomHUDIndicatorView(size: size, barStyle: barStyle)
            addSubview(iconView!)
            wisdom_addConstraint(toCenterX: iconView!, toCenterY: iconView!)
        case .progressArc:
            iconView = WisdomHUDProgressArcView(size: size, barStyle: barStyle)
            addSubview(iconView!)
            
            wisdom_addConstraint(with: iconView!,
                              topView: self,
                             leftView: self,
                           bottomView: self,
                            rightView: self,
                            edgeInset: UIEdgeInsets.zero)
        case .tadpoleArc:
            iconView = WisdomHUDTadpoleArcView(size: size, barStyle: barStyle)
            addSubview(iconView!)
            
            wisdom_addConstraint(with: iconView!,
                              topView: self,
                             leftView: self,
                           bottomView: self,
                            rightView: self,
                            edgeInset: UIEdgeInsets.zero)
        case .chaseBall:
            iconView = WisdomHUDChaseBallView(size: size, barStyle: barStyle)
            addSubview(iconView!)
            
            wisdom_addConstraint(with: iconView!,
                              topView: self,
                             leftView: self,
                           bottomView: self,
                            rightView: self,
                            edgeInset: UIEdgeInsets.zero)
        default: break
        }
    }
    
    func setSuccessIcon(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        iconView?.removeFromSuperview()
        
        iconView = WisdomHUDSuccessView(size: size, barStyle: barStyle)
        addSubview(iconView!)
        
        wisdom_addConstraint(with: iconView!,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        (iconView as? WisdomHUDSuccessView)?.beginAnimation(isRepeat: false)
    }
    
    func setErrorIcon(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        iconView?.removeFromSuperview()
        
        iconView = WisdomHUDErrorView(size: size, barStyle: barStyle)
        addSubview(iconView!)
        
        wisdom_addConstraint(with: iconView!,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        (iconView as? WisdomHUDErrorView)?.beginAnimation(isRepeat: false)
    }
    
    func setWarningIcon(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        iconView?.removeFromSuperview()
        
        iconView = WisdomHUDWarningView(size: size, barStyle: barStyle)
        addSubview(iconView!)
        
        wisdom_addConstraint(with: iconView!,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        (iconView as? WisdomHUDWarningView)?.beginAnimation(isRepeat: false)
    }
}
