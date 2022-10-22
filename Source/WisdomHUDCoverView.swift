//
//  WisdomHUDCoverView.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/10/20.
//

import UIKit


final class WisdomHUDCoverView: UIView {
    
    private(set) var focusing = false
    
    var sceneView: WisdomHUDSceneView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomHUDCoverView: WisdomHUDContextable {
    
    func setFocusing(){
        focusing = true
        
        if let cur_sceneView = sceneView {
            backgroundColor = UIColor.clear
            
            let coverConstraints = constraints.filter {
                $0.identifier == WisdomHUDOperate.getWisdom_Focusing()
            }
            let superConstraints = superview?.constraints.filter {
                $0.identifier == WisdomHUDOperate.getWisdom_Focusing()
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
        }
    }
}
