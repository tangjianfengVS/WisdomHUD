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
    
    static func setTextPlaceStyle(textStyle: WisdomTextPlaceStyle)
    
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
    
    static func showSuccess(text: String)
    
    static func showSuccess(text: String, inSupView: UIView?) // inSupView
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle) // barStyle
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) // barStyle/inSupView
    
    static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // inSupView/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/inSupView/delays
}

protocol WisdomHUDErrorable {
    
    static func showError(text: String)
    
    static func showError(text: String, inSupView: UIView?) // inSupView
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle) // barStyle
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) // barStyle/inSupView
    
    static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // inSupView/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/inSupView/delays
}

protocol WisdomHUDWarningable {
    
    static func showWarning(text: String)
    
    static func showWarning(text: String, inSupView: UIView?) // inSupView
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle) // barStyle
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) // barStyle/inSupView
    
    static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // inSupView/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/inSupView/delays
}

protocol WisdomHUDTextCenterable {
    
    static func showTextCenter(text: String)
    
    static func showTextCenter(text: String, inSupView: UIView?) // inSupView
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle) // barStyle
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) // barStyle/inSupView
    
    static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // inSupView/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/inSupView/delays
}

protocol WisdomHUDTextBottomable {
    
    static func showTextBottom(text: String)
    
    static func showTextBottom(text: String, inSupView: UIView?) // inSupView
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle) // barStyle
    
    static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) // barStyle/inSupView
    
    static func showTextBottom(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // inSupView/delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/delays
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) // barStyle/inSupView/delays
}

protocol WisdomHUDContentable {
    
    func setLoadingContent(text: String, loadingStyle: WisdomLoadingStyle)
    
    func setSuccessContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setErrorContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
    
    func setWarningContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)
    
    func showTextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)
}

protocol WisdomHUDDelaysable {
    
    func startDelays(delays: TimeInterval)
    
    func endAnimate(delays: TimeInterval)
    
    func executeDelayClosure()
}

protocol WisdomHUDSetIconable {
    
    func setLoadingIcon(size: CGFloat, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle)
    
    func setSuccessIcon(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setErrorIcon(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setWarningIcon(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
}
