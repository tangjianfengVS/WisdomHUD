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

final class WisdomHUDProgreContext: WisdomHUDLoadingContext {
    
    private(set) var progreColor: UIColor?
    
    private(set) var progreValue: UInt?
    
    private(set) var progreTextColor: UIColor?
    
    private(set) var progreShadowColor: UIColor?
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

extension WisdomHUDProgreContext: WisdomHUDProgreContextable {
    
    // MARK: Set HUD CoverView Progre Value
    public func setProgreValue(value: UInt)->Self {
        if Thread.isMainThread {
            doProgreValue()
        }else {
            DispatchQueue.main.async { doProgreValue() }
        }
        
        func doProgreValue(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.progreValue = nil
                _=coverVI.setProgreValue(value: value)
            }else {
                self.progreValue = value
            }
        }
        return self
    }
    
    // MARK: Set HUD CoverView Progre Color
    public func setProgreColor(color: UIColor)->Self {
        if Thread.isMainThread {
            doProgreColor()
        }else {
            DispatchQueue.main.async { doProgreColor() }
        }
        
        func doProgreColor(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.progreColor = nil
                _=coverVI.setProgreColor(color: color)
            }else {
                self.progreColor = color
            }
        }
        return self
    }
    
    // MARK: Set the Progre Context text color
    @discardableResult
    @objc func setProgreTextColor(color: UIColor)->Self{
        if Thread.isMainThread {
            doProgreTextColor()
        }else {
            DispatchQueue.main.async { doProgreTextColor() }
        }
        
        func doProgreTextColor(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.progreTextColor = nil
                _=coverVI.setProgreTextColor(color: color)
            }else {
                self.progreTextColor = color
            }
        }
        return self
    }
    
    // MARK: Set the Progre Context Shadow color
    @discardableResult
    @objc func setProgreShadowColor(color: UIColor)->Self {
        if Thread.isMainThread {
            doProgreShadowColor()
        }else {
            DispatchQueue.main.async { doProgreShadowColor() }
        }
        
        func doProgreShadowColor(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.progreShadowColor = nil
                _=coverVI.setProgreShadowColor(color: color)
            }else {
                self.progreShadowColor = color
            }
        }
        return self
    }
}


class WisdomHUDActionContext {
    
    private(set) weak var coverView: UIView? // CoverView
    
    private(set) var leftAction: (TextColor:UIColor?, TextFont:UIFont?)?
    
    private(set) var rightAction: (TextColor:UIColor?, TextFont:UIFont?)?
}

extension WisdomHUDActionContext {
    
    func setCoverView(coverView: UIView) {
        self.coverView = coverView
    }
}

extension WisdomHUDActionContext: WisdomHUDActionContextable {
    
    func setLeftAction(textColor: UIColor?, textFont: UIFont?)->Self{
        if textColor==nil && textFont==nil { return self }
        if Thread.isMainThread {
            doLeftAction()
        }else {
            DispatchQueue.main.async { doLeftAction() }
        }
        
        func doLeftAction(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.leftAction = nil
                _=coverVI.setLeftAction(textColor: textColor, textFont: textFont)
            }else {
                self.leftAction = (textColor, textFont)
            }
        }
        return self
    }
    
    func setRightAction(textColor: UIColor?, textFont: UIFont?)->Self{
        if textColor==nil && textFont==nil {
            return self
        }
        if Thread.isMainThread {
            doRightAction()
        }else {
            DispatchQueue.main.async { doRightAction() }
        }
        
        func doRightAction(){
            if let coverVI = coverView as? WisdomHUDCoverView {
                self.rightAction = nil
                _=coverVI.setRightAction(textColor: textColor, textFont: textFont)
            }else {
                self.rightAction = (textColor, textFont)
            }
        }
        return self
    }
}

