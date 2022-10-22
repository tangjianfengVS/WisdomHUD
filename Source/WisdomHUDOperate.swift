//
//  WisdomHUDTask.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/9/29.
//

import UIKit


struct WisdomHUDOperate {
    
    fileprivate static var WisdomLoadingStyle: WisdomLoadingStyle = .rotate

    fileprivate static var WisdomSceneBarStyle: WisdomSceneBarStyle = .dark

    fileprivate static var WisdomDisplayDelays: TimeInterval = 2.2
    
    fileprivate static var WisdomCoverBackgColor = UIColor(white: 0, alpha: 0.35)

    fileprivate static let WisdomHUDCoverTag = 221010
    
    //static let WisdomCache = NSCache<NSString, UIImage>()
    static func getWisdom_Focusing()->String { return "Wisdom_Focusing"}
}

extension WisdomHUDOperate: WisdomHUDSettingable {
    
    static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        WisdomLoadingStyle = loadingStyle
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
    
    static func getScreenWindow() -> UIWindow? {
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
    
    static func isSmallScreen() -> Bool {
        func getWidth() -> CGFloat {
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
                                     inSupView: UIView?) -> (WisdomHUDCoverView, WisdomHUDSceneView)? {
        var cur_inSupView = inSupView
        if cur_inSupView == nil { cur_inSupView = getScreenWindow() }
        
        if let rootVI = cur_inSupView {
            if let coverView = rootVI.viewWithTag(WisdomHUDCoverTag) as? WisdomHUDCoverView {
                if coverView.focusing {
                    coverView.removeFromSuperview()
                    return createCoverView(rootVI: rootVI)
                }
                
                if let sceneView = coverView.sceneView, sceneView.hudStyle == hudStyle {
                    sceneView.executeDelayClosure()
                    sceneView.setStyleContent(barStyle: barStyle, placeStyle: placeStyle)
                    return (coverView, sceneView)
                }
                
                coverView.sceneView?.removeFromSuperview()
                return (coverView, createAndSetupSceneView(supView: coverView))
            }else {
                return createCoverView(rootVI: rootVI)
            }
        }
        
        func createCoverView(rootVI: UIView) -> (WisdomHUDCoverView, WisdomHUDSceneView)? {
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
        
        func createAndSetupSceneView(supView: WisdomHUDCoverView) -> WisdomHUDSceneView {
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
                    offsetConstant.identifier = WisdomHUDOperate.getWisdom_Focusing()
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
}

extension WisdomHUDOperate: WisdomHUDLoadingable {
    
    static func showLoading(text: String) {
        showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, inSupView: UIView?) {
        showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle) {
        showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle) {
        showLoading(text: text, loadingStyle: loadingStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle) {
        showLoading(text: text, loadingStyle: loadingStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: UIView?) {
        showLoading(text: text, loadingStyle: loadingStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: barStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD(){
            if let sceneView = getSceneView(hudStyle: .loading, barStyle: barStyle, inSupView: inSupView)?.1 {
                sceneView.setLoadingContent(text: text, loadingStyle: loadingStyle)
            }
        }
    }
}

extension WisdomHUDOperate: WisdomHUDSuccessable {
    
    static func showSuccess(text: String)->WisdomHUDContext {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: UIView?)->WisdomHUDContext {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext {
        return showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext {
        return showSuccess(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)->WisdomHUDContext {
        return showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .succes, barStyle: barStyle, inSupView: inSupView) {
                context.coverView = contentView.0
                contentView.1.setSuccessContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                if context.focusing {
                    context.setFocusing()
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDErrorable {
    
    static func showError(text: String)->WisdomHUDContext {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: UIView?)->WisdomHUDContext {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext {
        return showError(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext {
        return showError(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)->WisdomHUDContext {
        return showError(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .error, barStyle: barStyle, inSupView: inSupView) {
                context.coverView = contentView.0
                contentView.1.setErrorContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                if context.focusing {
                    context.setFocusing()
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDWarningable {
    
    static func showWarning(text: String)->WisdomHUDContext {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: UIView?)->WisdomHUDContext {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext {
        return showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext {
        return showWarning(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)->WisdomHUDContext {
        return showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .warning, barStyle: barStyle, inSupView: inSupView) {
                context.coverView = contentView.0
                contentView.1.setWarningContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDTextCenterable {
    
    static func showTextCenter(text: String)->WisdomHUDContext {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: UIView?)->WisdomHUDContext {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext {
        showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext {
        showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)->WisdomHUDContext {
        showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .text, placeStyle: .center, barStyle: barStyle, inSupView: inSupView) {
                context.coverView = contentView.0
                contentView.1.setTextContent(text: text, delays: delays, delayClosure: delayClosure)
                if context.focusing {
                    context.setFocusing()
                }
            }
        }
        return context
    }
}

extension WisdomHUDOperate: WisdomHUDTextBottomable {
    
    static func showTextBottom(text: String)->WisdomHUDContext {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: UIView?)->WisdomHUDContext {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)->WisdomHUDContext {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext {
        let context = WisdomHUDContext()
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let contentView = getSceneView(hudStyle: .text, placeStyle: .bottom, barStyle: barStyle, inSupView: inSupView) {
                context.coverView = contentView.0
                contentView.1.setTextContent(text: text, delays: delays, delayClosure: delayClosure)
                if context.focusing {
                    context.setFocusing()
                }
            }
        }
        return context
    }
}
