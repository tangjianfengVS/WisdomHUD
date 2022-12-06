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

class WisdomHUDLoadingContext: WisdomHUDBaseContext {
    
    private(set) var timeout: (TimeInterval, (TimeInterval)->())?
}

final class WisdomHUDProgressContext: WisdomHUDLoadingContext {
    
    private(set) var progressColor: UIColor?
    
    private(set) var progressValue: UInt?
    
    private(set) var progressTextColor: UIColor?
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

extension WisdomHUDProgressContext: WisdomHUDProgressContextable {
    
    // MARK: Set HUD CoverView Progress Value
    public func setProgressValue(value: UInt)->Self {
        if Thread.isMainThread {
            doProgressValue()
        }else {
            DispatchQueue.main.async { doProgressValue() }
        }
        
        func doProgressValue(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.progressValue = nil
                _=coverVI.setProgressValue(value: value)
            }else {
                self.progressValue = value
            }
        }
        return self
    }
    
    // MARK: Set HUD CoverView Progress Color
    public func setProgressColor(color: UIColor)->Self {
        if Thread.isMainThread {
            doProgressColor()
        }else {
            DispatchQueue.main.async { doProgressColor() }
        }
        
        func doProgressColor(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.progressColor = nil
                _=coverVI.setProgressColor(color: color)
            }else {
                self.progressColor = color
            }
        }
        return self
    }
    
    // MARK: Set the Progress Context text color
    @discardableResult
    @objc func setProgressTextColor(color: UIColor)->Self{
        if Thread.isMainThread {
            doProgressTextColor()
        }else {
            DispatchQueue.main.async { doProgressTextColor() }
        }
        
        func doProgressTextColor(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.progressTextColor = nil
                _=coverVI.setProgressTextColor(color: color)
            }else {
                self.progressTextColor = color
            }
        }
        return self
    }
}
