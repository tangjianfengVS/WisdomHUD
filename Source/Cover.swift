//
//  Cover.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/10/20.
//

import UIKit


final class WisdomHUDCoverView: UIView {
    
    private(set) var isSetting = false
    
    weak var sceneView: WisdomHUDSceneView?
    
    weak var actionView: WisdomHUDActionThemeView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.classForCoder) deinit")
    }
}

extension WisdomHUDCoverView: WisdomHUDContextable {
    
    func setFocusing()->Self {
        isSetting = true
        
        if let cur_sceneView = sceneView {
            backgroundColor = UIColor.clear
            
            let coverConstraints = constraints.filter {
                $0.identifier == WisdomHUDCore.getWisdomHUD_Focusing()
            }
            let superConstraints = superview?.constraints.filter {
                $0.identifier == WisdomHUDCore.getWisdomHUD_Focusing()
            }
            removeConstraints(coverConstraints)
            superview?.removeConstraints(superConstraints ?? [])
            
            superview?.layoutIfNeeded()
            if cur_sceneView.placeStyle == .bottom {
                superview?.wisdom_addConstraint(toCenterX: self, toCenterY: nil)
                superview?.addConstraint(NSLayoutConstraint(item: self,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                          toItem: superview,
                                                       attribute: .bottom,
                                                      multiplier: 1.0,
                                                        constant: -(superview?.frame.height ?? 0)/10.5))
            }else {
                superview?.wisdom_addConstraint(toCenterX: self, toCenterY: self)
            }
            
            wisdom_addConstraint(with: cur_sceneView,
                                 topView: self,
                                 leftView: self,
                                 bottomView: self,
                                 rightView: self,
                                 edgeInset: UIEdgeInsets.zero)
            
            if cur_sceneView.hudStyle != .text{
                cur_sceneView.set_imageContentSize()
            }
        }
        return self
    }
}

extension WisdomHUDCoverView: WisdomHUDLoadingContextable {
    
    func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self {
        isSetting = true
        _=sceneView?.setTimeout(time: time, timeoutClosure: timeoutClosure)
        return self
    }
}

extension WisdomHUDCoverView: WisdomHUDBaseContextable {
    
    func setTextFont(font: UIFont)->Self {
        _=sceneView?.setTextFont(font: font)
        return self
    }
    
    func setTextColor(color: UIColor)->Self {
        _=sceneView?.setTextColor(color: color)
        return self
    }
    
    func setUpdateText(text: String)->Self {
        _=sceneView?.setUpdateText(text: text)
        return self
    }
    
    func setAnimation(view: UIView)->Self {
        isSetting = true
        _=sceneView?.setAnimation(view: view)
        return self
    }
}

extension WisdomHUDCoverView: WisdomHUDProgreContextable {
    
    func setProgreColor(color: UIColor)->Self {
        _=sceneView?.setProgreColor(color: color)
        return self
    }
    
    func setProgreValue(value: UInt)->Self {
        _=sceneView?.setProgreValue(value: value)
        return self
    }
    
    func setProgreTextColor(color: UIColor)->Self {
        _=sceneView?.setProgreTextColor(color: color)
        return self
    }
    
    func setProgreShadowColor(color: UIColor)->Self {
        _=sceneView?.setProgreShadowColor(color: color)
        return self
    }
}

extension WisdomHUDCoverView: WisdomHUDActionContextable {
    
    func setLeftAction(textColor: UIColor?, textFont: UIFont?)->Self {
        _=actionView?.setLeftAction(textColor: textColor, textFont: textFont)
        return self
    }
    
    func setRightAction(textColor: UIColor?, textFont: UIFont?)->Self {
        _=actionView?.setRightAction(textColor: textColor, textFont: textFont)
        return self
    }
    
    func setTextAlignment(alignment: NSTextAlignment)->Self {
        _=actionView?.setTextAlignment(alignment: alignment)
        return self
    }
    
    func setActionTextFont(font: UIFont)->Self {
        _=actionView?.setTextFont(font: font)
        return self
    }
    
    func setActionTextColor(color: UIColor)->Self {
        _=actionView?.setTextColor(color: color)
        return self
    }
    
    func setLabelFont(font: UIFont) -> Self {
        _=actionView?.setLabelFont(font: font)
        return self
    }
    
    func setLabelColor(color: UIColor) -> Self {
        _=actionView?.setLabelColor(color: color)
        return self
    }
}
