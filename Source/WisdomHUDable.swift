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
    
    static func showLoading(text: String)
    
    static func showLoading(text: String, inSupView: UIView?) // inSupView
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle) // barStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle) // loadingStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle) // loadingStyle/barStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: UIView?) // loadingStyle/inSupView
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) // barStyle/inSupView
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?) // loadingStyle/barStyle/inSupView
}

protocol WisdomHUDSuccessable {
    
    static func showSuccess(text: String)->WisdomHUDContext
    
    static func showSuccess(text: String, inSupView: UIView?)->WisdomHUDContext // inSupView
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext // barStyle
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext // barStyle/inSupView
    
    static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // inSupView/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/inSupView/delays
}

protocol WisdomHUDErrorable {
    
    static func showError(text: String)->WisdomHUDContext
    
    static func showError(text: String, inSupView: UIView?)->WisdomHUDContext // inSupView
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext // barStyle
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext // barStyle/inSupView
    
    static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // inSupView/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/inSupView/delays
}

protocol WisdomHUDWarningable {
    
    static func showWarning(text: String)->WisdomHUDContext
    
    static func showWarning(text: String, inSupView: UIView?)->WisdomHUDContext // inSupView
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext // barStyle
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext // barStyle/inSupView
    
    static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // inSupView/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/inSupView/delays
}

protocol WisdomHUDTextCenterable {
    
    static func showTextCenter(text: String)->WisdomHUDContext
    
    static func showTextCenter(text: String, inSupView: UIView?)->WisdomHUDContext // inSupView
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext // barStyle
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext // barStyle/inSupView
    
    static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // inSupView/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/inSupView/delays
}

protocol WisdomHUDTextBottomable {
    
    static func showTextBottom(text: String)->WisdomHUDContext
    
    static func showTextBottom(text: String, inSupView: UIView?)->WisdomHUDContext // inSupView
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContext // barStyle
    
    static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContext // barStyle/inSupView
    
    static func showTextBottom(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // inSupView/delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContext // barStyle/inSupView/delays
}

protocol WisdomHUDContentable {
    
    func setLoadingContent(text: String, loadingStyle: WisdomLoadingStyle)
    
    func setSuccessContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setErrorContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setWarningContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)
    
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

protocol WisdomHUDContextable {
    
    func setFocusing()
}
