//
//  WisdomHUDable.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/9/29.
//

import UIKit


protocol WisdomHUDSettingable {

    static func setLoadingStyle(loadingStyle: WisdomLoadingStyle)
    
    static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle)
    
    static func setDisplayDelay(delayTime: CGFloat)
    
    static func setCoverBackgColor(backgColor: UIColor) 
}

protocol WisdomHUDGlobalable {
    
    static func isSmallScreen() -> Bool
    
    static func getScreenWindow() -> UIWindow?
    
    static func dismiss()
}

protocol WisdomHUDLoadingable {
    
    static func showLoading(text: String)->WisdomHUDLoadingContextable
    
    static func showLoading(text: String, inSupView: UIView?)->WisdomHUDLoadingContextable // inSupView
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable // barStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle)->WisdomHUDLoadingContextable // loadingStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable // loadingStyle/barStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: UIView?)->WisdomHUDLoadingContextable // loadingStyle/inSupView
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDLoadingContextable // barStyle/inSupView
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDLoadingContextable // loadingStyle/barStyle/inSupView
}

protocol WisdomHUDSuccessable {
    
    static func showSuccess(text: String)->WisdomHUDContextable
    
    static func showSuccess(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

protocol WisdomHUDErrorable {
    
    static func showError(text: String)->WisdomHUDContextable
    
    static func showError(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

protocol WisdomHUDWarningable {
    
    static func showWarning(text: String)->WisdomHUDContextable
    
    static func showWarning(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

protocol WisdomHUDTextCenterable {
    
    static func showTextCenter(text: String)->WisdomHUDContextable
    
    static func showTextCenter(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

protocol WisdomHUDTextBottomable {
    
    static func showTextBottom(text: String)->WisdomHUDContextable
    
    static func showTextBottom(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showTextBottom(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

protocol WisdomHUDContentable {
    
    func setLoadingContent(text: String, loadingStyle: WisdomLoadingStyle, timeout: (TimeInterval, (TimeInterval)->())?)
    
    func setSuccessContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setErrorContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setWarningContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setTextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setStyleContent(barStyle: WisdomSceneBarStyle, placeStyle: WisdomTextPlaceStyle?)
    
    func setDismissImage()
}

protocol WisdomHUDDelaysable {
    
    func startDelays(delays: TimeInterval)
    
    func endAnimate(delays: TimeInterval)
    
    func executeDelayClosure()
}

protocol WisdomHUDSetImageable {
    
    func setLoadingImage(size: CGFloat, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle)
    
    func setSuccessImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setErrorImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setWarningImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setDismissImage()
}

@objc public protocol WisdomHUDBaseContextable {
    
    @discardableResult
    @objc func setTextFont(font: UIFont)->Self
    
    @discardableResult
    @objc func setTextColor(color: UIColor)->Self
}

@objc public protocol WisdomHUDContextable: WisdomHUDBaseContextable {
    
    @discardableResult
    @objc func setFocusing()->Self
}

@objc public protocol WisdomHUDLoadingContextable: WisdomHUDBaseContextable {
    
    @discardableResult
    @objc func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self
}
