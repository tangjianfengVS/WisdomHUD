//
//  WisdomHUDContext.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/10/18.
//

import UIKit


class WisdomHUDBaseContext {
    
    private(set) weak var coverView: UIView? // CoverView
    
    private(set) var textFont: UIFont?
    
    private(set) var textColor: UIColor?
}

final class WisdomHUDContext: WisdomHUDBaseContext {
    
    private(set) var focusing = false
}

final class WisdomHUDLoadingContext: WisdomHUDBaseContext {
    
    private(set) var timeout: (TimeInterval, (TimeInterval)->())?
}


extension WisdomHUDBaseContext {
    
    func setCoverView(coverView: UIView) {
        self.coverView = coverView
    }
}


extension WisdomHUDBaseContext: WisdomHUDBaseContextable {

    // MARK: Set HUD CoverView Loading Text Font
    public func setTextFont(font: UIFont)->Self {
        if Thread.isMainThread {
            doTextFont()
        }else {
            DispatchQueue.main.async { doTextFont() }
        }
        
        func doTextFont(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.textFont = nil
                _=coverVI.setTextFont(font: font)
            }else {
                self.textFont = font
            }
        }
        return self
    }

    // MARK: Set HUD CoverView Loading Text Color
    public func setTextColor(color: UIColor)->Self {
        if Thread.isMainThread {
            doTextColor()
        }else {
            DispatchQueue.main.async { doTextColor() }
        }
        
        func doTextColor(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.textColor = nil
                _=coverVI.setTextColor(color: color)
            }else {
                self.textColor = color
            }
        }
        return self
    }
}

extension WisdomHUDContext: WisdomHUDContextable {
    
    // MARK: Set HUD CoverView Focusing
    public func setFocusing()->Self{
        if Thread.isMainThread{
            doFocusing()
        }else {
            DispatchQueue.main.async { doFocusing() }
        }
        
        func doFocusing(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                focusing = false
                _=coverVI.setFocusing()
            }else {
                focusing = true
            }
        }
        return self
    }
}

extension WisdomHUDLoadingContext: WisdomHUDLoadingContextable {
    
    // MARK: Set HUD CoverView Loading Timeout
    public func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self {
        if Thread.isMainThread{
            doTimeout()
        }else {
            DispatchQueue.main.async { doTimeout() }
        }
        
        func doTimeout(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                timeout = nil
                _=coverVI.setTimeout(time: time, timeoutClosure: timeoutClosure)
            }else {
                timeout = (time, timeoutClosure)
            }
        }
        return self
    }
}
