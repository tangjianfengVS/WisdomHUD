//
//  WisdomHUDContext.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/10/18.
//

import UIKit


class WisdomHUDBaseContext {
    
    private(set) weak var coverView: UIView? // CoverView
    
    private(set) var isSetting = false
    
    //    private(set) var textFont: UIFont?
    //
    //    private(set) var textColor: UIColor?
}

extension WisdomHUDBaseContext {
    
    func setCoverView(coverView: UIView) {
        self.coverView = coverView
    }
}

//    func setTextFont(textFont: UIFont)->Self{
//        self.textFont = textFont
//        return self
//    }
//
//    func setTextColor(textColor: UIColor)->Self{
//        self.textColor = textColor
//        return self
//    }

final class WisdomHUDContext: WisdomHUDBaseContext {
    
    private(set) var focusing = false
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
            if let coverVI = coverView as? WisdomHUDCoverView {
                focusing = false
                coverVI.setFocusing()
            }else {
                focusing = true
            }
        }
    }
}


class WisdomHUDLoadingContext: WisdomHUDBaseContext {
    
    private(set) var timeout: (TimeInterval, (TimeInterval)->())?
}

extension WisdomHUDLoadingContext: WisdomHUDLoadingContextable {
    
    // MARK: Set HUD CoverView Loading Timeout
    @objc public func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->())){
        if let coverVI = coverView as? WisdomHUDCoverView {
            timeout = nil
            coverVI.setTimeout(time: time, timeoutClosure: timeoutClosure)
        }else {
            timeout = (time, timeoutClosure)
        }
    }
}
