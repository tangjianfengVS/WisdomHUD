//
//  WisdomHUDTask.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/9/29.
//

import UIKit


struct WisdomHUDOperate {
    
    fileprivate static var WisdomLoadingStyle: WisdomLoadingStyle = .rotate
    
    fileprivate static var WisdomProgressStyle: WisdomProgressStyle = .circle

    fileprivate static var WisdomSceneBarStyle: WisdomSceneBarStyle = .dark
    
    fileprivate static var WisdomColorThemeStyle: WisdomColorThemeStyle = .light

    fileprivate static var WisdomDisplayDelays: TimeInterval = 2.2
    
    fileprivate static var WisdomCoverBackgColor = UIColor(white: 0, alpha: 0.35)

    fileprivate static let WisdomHUDCoverTag = 221010
    
    //static let WisdomCache = NSCache<NSString, UIImage>()
    static func getWisdomHUD_Focusing()->String { return "WisdomHUD_Focusing"}
}

extension WisdomHUDOperate: WisdomHUDSettingable {
    
    static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        WisdomLoadingStyle = loadingStyle
    }
    
    static func setProgressStyle(progressStyle: WisdomProgressStyle) {
        WisdomProgressStyle = progressStyle
    }
    
    static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle) {
        WisdomSceneBarStyle = sceneBarStyle
    }
    
    static func setDisplayDelay(delayTime: CGFloat) {
        WisdomDisplayDelays = delayTime
    }
    
    static func setCoverBackgColor(backgColor: UIColor) {
        WisdomCoverBackgColor = backgColor
    }
}

extension WisdomHUDOperate: WisdomHUDGlobalable {
    
    static func dismiss() {
        if Thread.isMainThread {
            remove()
        }else {
            DispatchQueue.main.async { remove() }
        }
        func remove(){
            let window = WisdomHUDOperate.getScreenWindow()
            let coverVI = window?.viewWithTag(WisdomHUDCoverTag)
            if let hudCoverVI = coverVI as? WisdomHUDCoverView {
                hudCoverVI.sceneView?.setDismissImage()
                
                hudCoverVI.removeFromSuperview()
            }
        }
    }
    
    static func dismissAction() {
        if Thread.isMainThread {
            remove()
        }else {
            DispatchQueue.main.async { remove() }
        }
        func remove(){
            let window = WisdomHUDOperate.getScreenWindow()
            let coverVI = window?.viewWithTag(WisdomHUDCoverTag>>1)
            if let hudCoverVI = coverVI as? WisdomHUDCoverView {
                hudCoverVI.removeFromSuperview()
            }
        }
    }
    
    static func getScreenWindow()->UIWindow? {
        var screenWindow = UIApplication.shared.delegate?.window
        if screenWindow == nil {
            screenWindow = UIApplication.shared.keyWindow

            if screenWindow == nil {
                for currentWindow in UIApplication.shared.windows {
                    if type(of: currentWindow) == UIWindow.self {
                        screenWindow = currentWindow
                        break
                    }
                }
            }
        }
        return screenWindow ?? nil
    }
    
    static func isSmallScreen()->Bool {
        func getWidth()->CGFloat {
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                return UIScreen.main.bounds.height
            }else {
                return UIScreen.main.bounds.width
            }
        }
        let resWidth = getWidth()
        return resWidth <= 380.0 ? true : false
    }
    
    private static func getSceneView(hudStyle: WisdomHUDStyle,
                                     placeStyle: WisdomTextPlaceStyle?=nil,
                                     barStyle: WisdomSceneBarStyle,
                                     inSupView: UIView?)->(WisdomHUDCoverView, WisdomHUDSceneView)? {
        var cur_inSupView = inSupView
        if cur_inSupView == nil { cur_inSupView = getScreenWindow() }
        
        if let rootVI = cur_inSupView {
            if let coverView = rootVI.viewWithTag(WisdomHUDCoverTag) as? WisdomHUDCoverView {
                if coverView.isSetting {
                    
                    coverView.sceneView?.setDismissImage()
                    coverView.removeFromSuperview()
                    return createCoverView(rootVI: rootVI)
                }
                
                if let sceneView = coverView.sceneView, sceneView.hudStyle == hudStyle {
                    sceneView.executeDelayClosure()
                    sceneView.setStyleContent(barStyle: barStyle, placeStyle: placeStyle)
                    coverView.alpha = 1
                    return (coverView, sceneView)
                }
                
                coverView.sceneView?.setDismissImage()
                coverView.sceneView?.removeFromSuperview()
                coverView.alpha = 1
                return (coverView, createAndSetupSceneView(supView: coverView))
            }else {
                return createCoverView(rootVI: rootVI)
            }
        }
        
        func createCoverView(rootVI: UIView)->(WisdomHUDCoverView, WisdomHUDSceneView)? {
            let coverView = WisdomHUDCoverView()
            coverView.tag = WisdomHUDCoverTag
            coverView.backgroundColor = WisdomCoverBackgColor
            
            rootVI.insertSubview(coverView, at: rootVI.subviews.count+50)
            rootVI.wisdom_addConstraint(with: coverView,
                                     topView: rootVI,
                                    leftView: rootVI,
                                  bottomView: rootVI,
                                   rightView: rootVI,
                                   edgeInset: UIEdgeInsets.zero)
            return (coverView, createAndSetupSceneView(supView: coverView))
        }
        
        func createAndSetupSceneView(supView: WisdomHUDCoverView)->WisdomHUDSceneView {
            let sceneView = WisdomHUDSceneView(hudStyle: hudStyle, barStyle: barStyle, placeStyle: placeStyle)
            supView.sceneView = sceneView
            supView.addSubview(sceneView)
            
            if hudStyle == .text {
                switch placeStyle {
                case .center:
                    supView.wisdom_addConstraint(toCenterX: sceneView, toCenterY: sceneView)
                case .bottom:
                    supView.layoutIfNeeded()
                    supView.wisdom_addConstraint(toCenterX: sceneView, toCenterY: nil)
                    
                    let offsetConstant = NSLayoutConstraint(item: sceneView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                          toItem: supView,
                                                       attribute: .bottom,
                                                      multiplier: 1.0,
                                                        constant: -supView.frame.height/10.5)
                    offsetConstant.identifier = WisdomHUDOperate.getWisdomHUD_Focusing()
                    supView.addConstraint(offsetConstant)
                default: break
                }
            }else {
                supView.wisdom_addConstraint(toCenterX: sceneView, toCenterY: sceneView)
            }
            return sceneView
        }
        return nil
    }
    
    private static func setupActionView(inSupView: UIView?, actionView: WisdomHUDActionThemeView) {
        let window = WisdomHUDOperate.getScreenWindow()
        let coverVI = window?.viewWithTag(WisdomHUDCoverTag>>1) as? WisdomHUDCoverView
        coverVI?.actionView?.removeFromSuperview()
        
        var cur_inSupView = inSupView
        if inSupView == nil, let cur_window = window {
            coverVI?.actionView = actionView
            cur_inSupView = coverVI
            
            if cur_inSupView == nil {
                let coverView = WisdomHUDCoverView()
                coverView.tag = WisdomHUDCoverTag>>1
                coverView.actionView = actionView
                coverView.backgroundColor = WisdomCoverBackgColor
                cur_inSupView = coverView
                
                cur_window.addSubview(coverView)
                cur_window.wisdom_addConstraint(with: coverView,
                                                topView: cur_window,
                                                leftView: cur_window,
                                                bottomView: cur_window,
                                                rightView: cur_window,
                                                edgeInset: UIEdgeInsets.zero)
            }
        }else if inSupView != nil {
            coverVI?.removeFromSuperview()
        }
        
        if let rootVI = cur_inSupView {
            rootVI.addSubview(actionView)
            rootVI.wisdom_addConstraint(toCenterX: actionView, toCenterY: actionView)
            actionView.wisdom_addConstraint(width: WisdomHUDOperate.isSmallScreen() ? 280 : 310, height: -1)
        }
    }
   
}

extension WisdomHUDOperate: WisdomHUDLoadingable {
    
    static func showLoading(text: String)->WisdomHUDLoadingContextable {
        return showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, inSupView: UIView?)->WisdomHUDLoadingContextable {
        showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable {
        return showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle)->WisdomHUDLoadingContextable {
        return showLoading(text: text, loadingStyle: loadingStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable {
        showLoading(text: text, loadingStyle: loadingStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: UIView?)->WisdomHUDLoadingContextable {
        return showLoading(text: text, loadingStyle: loadingStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDLoadingContextable {
        return showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: barStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDLoadingContextable {
        let context = WisdomHUDLoadingContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD(){
            if let contentView = getSceneView(hudStyle: .loading, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: contentView.0)
                contentView.1.setLoadingContent(text: text, loadingStyle: loadingStyle, timeout: context.timeout)
                
                if let textColor = context.textColor {
                    _=context.setTextColor(color: textColor)
                }
                
                if let textFont = context.textFont {
                    _=context.setTextFont(font: textFont)
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate:  WisdomHUDProgressable {
    
    static func showProgress(text: String)->WisdomHUDProgreContextable {
        return showProgress(text: text, progressStyle: WisdomProgressStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, inSupView: UIView?)->WisdomHUDProgreContextable {
        return showProgress(text: text, progressStyle: WisdomProgressStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showProgress(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDProgreContextable {
        return showProgress(text: text, progressStyle: WisdomProgressStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, progressStyle: WisdomProgressStyle)->WisdomHUDProgreContextable {
        return showProgress(text: text, progressStyle: progressStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, progressStyle: WisdomProgressStyle, barStyle: WisdomSceneBarStyle)->WisdomHUDProgreContextable {
        return showProgress(text: text, progressStyle: progressStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, progressStyle: WisdomProgressStyle, inSupView: UIView?)->WisdomHUDProgreContextable {
        return showProgress(text: text, progressStyle: progressStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showProgress(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDProgreContextable {
        return showProgress(text: text, progressStyle: WisdomProgressStyle, barStyle: barStyle, inSupView: inSupView)
    }
    
    static func showProgress(text: String, progressStyle: WisdomProgressStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDProgreContextable {
        let context = WisdomHUDProgreContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .progress, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: contentView.0)
                contentView.1.setProgressContent(text: text, progressStyle: progressStyle, timeout: context.timeout)
                
                if let textColor = context.textColor {
                    _=context.setTextColor(color: textColor)
                }
                if let textFont = context.textFont {
                    _=context.setTextFont(font: textFont)
                }
                
                if let progreColor = context.progreColor {
                    _=context.setProgreColor(color: progreColor)
                }
                if let progreValue = context.progreValue {
                    _=context.setProgreValue(value: progreValue)
                }
                if let progreTextColor = context.progreTextColor {
                    _=context.setProgreTextColor(color: progreTextColor)
                }
                if let progreShadowColor = context.progreShadowColor {
                    _=context.setProgreShadowColor(color: progreShadowColor)
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDSuccessable {
    
    static func showSuccess(text: String)->WisdomHUDContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: UIView?)->WisdomHUDContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable {
        return showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable {
        return showSuccess(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .succes, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: contentView.0)
                contentView.1.setSuccessContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                
                if context.focusing {
                    _=context.setFocusing()
                }
                
                if let textColor = context.textColor {
                    _=context.setTextColor(color: textColor)
                }
                
                if let textFont = context.textFont {
                    _=context.setTextFont(font: textFont)
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDErrorable {
    
    static func showError(text: String)->WisdomHUDContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: UIView?)->WisdomHUDContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable {
        return showError(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable {
        return showError(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showError(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .error, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: contentView.0)
                contentView.1.setErrorContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                
                if context.focusing {
                    _=context.setFocusing()
                }
                
                if let textColor = context.textColor {
                    _=context.setTextColor(color: textColor)
                }
                
                if let textFont = context.textFont {
                    _=context.setTextFont(font: textFont)
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDWarningable {
    
    static func showWarning(text: String)->WisdomHUDContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: UIView?)->WisdomHUDContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable {
        return showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable {
        return showWarning(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .warning, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: contentView.0)
                contentView.1.setWarningContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                
                if context.focusing {
                    _=context.setFocusing()
                }
                
                if let textColor = context.textColor {
                    _=context.setTextColor(color: textColor)
                }
                
                if let textFont = context.textFont {
                    _=context.setTextFont(font: textFont)
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDTextCenterable {
    
    static func showTextCenter(text: String)->WisdomHUDContextable {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: UIView?)->WisdomHUDContextable {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable {
        showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable {
        showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .text, placeStyle: .center, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: contentView.0)
                contentView.1.setTextContent(text: text, delays: delays, delayClosure: delayClosure)
                
                if context.focusing {
                    _=context.setFocusing()
                }
                
                if let textColor = context.textColor {
                    _=context.setTextColor(color: textColor)
                }
                
                if let textFont = context.textFont {
                    _=context.setTextFont(font: textFont)
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDTextBottomable {
    
    static func showTextBottom(text: String)->WisdomHUDContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: UIView?)->WisdomHUDContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .text, placeStyle: .bottom, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: contentView.0)
                contentView.1.setTextContent(text: text, delays: delays, delayClosure: delayClosure)
                
                if context.focusing {
                    _=context.setFocusing()
                }
                
                if let textColor = context.textColor {
                    _=context.setTextColor(color: textColor)
                }
                
                if let textFont = context.textFont {
                    _=context.setTextFont(font: textFont)
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDActionable {
    
    static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, inSupView: UIView?, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) {
        //let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            let actionView = WisdomHUDActionThemeView(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, actionClosure: actionClosure)
            setupActionView(inSupView: inSupView, actionView: actionView)
            actionView.setThemeStyle(themeStyle: themeStyle)
        }
    }
}
