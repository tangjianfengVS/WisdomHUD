//
//  WisdomHUDTask.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/9/29.
//

import UIKit


fileprivate final class WisdomHUDCoverView: UIView {
    var sceneView: WisdomHUDSceneView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismiss(){
        WisdomHUDOperate.dismiss()
    }
}


struct WisdomHUDOperate {
    
    fileprivate static var WisdomLoadingStyle: WisdomLoadingStyle = .rotate

    fileprivate static var WisdomSceneBarStyle: WisdomSceneBarStyle = .dark
    
    fileprivate static var WisdomTextPlaceStyle: WisdomTextPlaceStyle = .center

    fileprivate static var WisdomDisplayDelays: TimeInterval = 2.2
    
    fileprivate static var WisdomCoverBackgColor = UIColor(white: 0, alpha: 0.35)

    fileprivate static let WisdomHUDCoverTag = 221010
    
    //static let WisdomCache = NSCache<NSString, UIImage>()
}

extension WisdomHUDOperate: WisdomHUDSettingable {
    
    static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        WisdomLoadingStyle = loadingStyle
    }
    
    static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle) {
        WisdomSceneBarStyle = sceneBarStyle
    }
    
    static func setTextPlaceStyle(textStyle: WisdomTextPlaceStyle) {
        WisdomTextPlaceStyle = textStyle
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
                                     inSupView: UIView?) -> WisdomHUDSceneView? {
        var cur_inSupView = inSupView
        if cur_inSupView == nil { cur_inSupView = getScreenWindow() }
        
        if let rootVI = cur_inSupView {
            if let coverView = rootVI.viewWithTag(WisdomHUDCoverTag) as? WisdomHUDCoverView {
                if let sceneView = coverView.sceneView, sceneView.hudStyle == hudStyle {
                    sceneView.executeDelayClosure()
                    return sceneView
                }else {
                    coverView.sceneView?.removeFromSuperview()
                    return createAndSetupSceneView(supView: coverView)
                }
            }else {
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
                return createAndSetupSceneView(supView: coverView)
            }
        }
        
        func createAndSetupSceneView(supView: WisdomHUDCoverView) -> WisdomHUDSceneView {
            let sceneView = WisdomHUDSceneView(hudStyle: hudStyle, barStyle: barStyle)
            supView.sceneView = sceneView
            supView.addSubview(sceneView)
            
            if hudStyle == .text {
                switch placeStyle {
                case .center:
                    supView.wisdom_addConstraint(toCenterX: sceneView, toCenterY: sceneView)
                case .bottom:
                    supView.layoutIfNeeded()
                    supView.wisdom_addConstraint(toCenterX: sceneView, toCenterY: nil)
                    supView.addConstraint(NSLayoutConstraint(item: sceneView,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                           toItem: supView,
                                                        attribute: .bottom,
                                                       multiplier: 1.0,
                                                         constant: -supView.frame.height/10.5))
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
            if let sceneView = getSceneView(hudStyle: .loading, barStyle: barStyle, inSupView: inSupView) {
                sceneView.setLoadingContent(text: text, loadingStyle: loadingStyle)
            }
        }
    }
}

extension WisdomHUDOperate: WisdomHUDSuccessable {
    
    static func showSuccess(text: String) {
        showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: UIView?) {
        showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle) {
        showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        showSuccess(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let sceneView = getSceneView(hudStyle: .succes, barStyle: barStyle, inSupView: inSupView) {
                sceneView.setSuccessContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
            }
        }
    }
}

extension WisdomHUDOperate: WisdomHUDErrorable {
    
    static func showError(text: String) {
        showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: UIView?) {
        showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle) {
        showError(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        showError(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        showError(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let sceneView = getSceneView(hudStyle: .error, barStyle: barStyle, inSupView: inSupView) {
                sceneView.setErrorContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
            }
        }
    }
}

extension WisdomHUDOperate: WisdomHUDWarningable {
    
    static func showWarning(text: String) {
        showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: UIView?) {
        showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle) {
        showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        showWarning(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let sceneView = getSceneView(hudStyle: .warning, barStyle: barStyle, inSupView: inSupView) {
                sceneView.setWarningContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
            }
        }
    }
}

extension WisdomHUDOperate: WisdomHUDTextCenterable {
    
    static func showTextCenter(text: String) {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: UIView?) {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle) {
        showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let sceneView = getSceneView(hudStyle: .text, placeStyle: .center, barStyle: barStyle, inSupView: inSupView) {
                sceneView.showTextContent(text: text, delays: delays, delayClosure: delayClosure)
            }
        }
    }
}

extension WisdomHUDOperate: WisdomHUDTextBottomable {
    
    static func showTextBottom(text: String) {
        showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: UIView?) {
        showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle) {
        showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        if Thread.isMainThread {
            showHUD()
        }else {
            DispatchQueue.main.async { showHUD() }
        }
        func showHUD() {
            if let sceneView = getSceneView(hudStyle: .text, placeStyle: .bottom, barStyle: barStyle, inSupView: inSupView) {
                sceneView.showTextContent(text: text, delays: delays, delayClosure: delayClosure)
            }
        }
    }
}
