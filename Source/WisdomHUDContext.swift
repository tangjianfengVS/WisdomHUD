//
//  WisdomHUDContext.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/10/18.
//

import UIKit

@objc public final class WisdomHUDContext: NSObject {
    
    private(set) var focusing = false
    
    // CoverView
    weak var coverView: UIView?
    
}

extension WisdomHUDContext: WisdomHUDContextable {
    
    // MARK: Set HUD CoverView Focusing
    @objc public func setFocusing() {
        if Thread.isMainThread {
            doFocusing()
        }else {
            DispatchQueue.main.async { doFocusing() }
        }
        func doFocusing() {
            if let coverVI = coverView as? WisdomHUDCoverView{
                coverVI.setFocusing()
            }else {
                focusing = true
            }
        }
    }
}
