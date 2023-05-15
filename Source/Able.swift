//
//  Able.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/9/29.
//

import UIKit


public protocol WisdomHUDSettingable {

    static func setLoadingStyle(loadingStyle: WisdomLoadingStyle)
    
    static func setProgressStyle(progreStyle: WisdomProgreStyle)
    
    static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle)
    
    static func setTextMaxLines(maxLine: WisdomTextMaxLineStyle)
    
    static func setDisplayDelay(delayTime: CGFloat)
    
    static func setCoverBackgColor(backgColor: UIColor) 
}

public protocol WisdomHUDGlobalable {
    
    static func isSmallScreen() -> Bool
    
    static func getScreenWindow() -> UIWindow?
    
    static func dismiss()
    
    static func dismissAction()
}

public protocol WisdomHUDLoadingable {
    
    static func showLoading(text: String)->WisdomHUDLoadingContextable
    
    static func showLoading(text: String, inSupView: UIView?)->WisdomHUDLoadingContextable // inSupView
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable // barStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle)->WisdomHUDLoadingContextable // loadingStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable // loadingStyle/barStyle
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: UIView?)->WisdomHUDLoadingContextable // loadingStyle/inSupView
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDLoadingContextable // barStyle/inSupView
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDLoadingContextable // loadingStyle/barStyle/inSupView
}

public protocol WisdomHUDProgreable {
    
    static func showProgress(text: String)->WisdomHUDProgreContextable
    
    static func showProgress(text: String, inSupView: UIView?)->WisdomHUDProgreContextable // inSupView
    
    static func showProgress(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDProgreContextable // barStyle
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle)->WisdomHUDProgreContextable // progreStyle
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle)->WisdomHUDProgreContextable // progreStyle/barStyle
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle, inSupView: UIView?)->WisdomHUDProgreContextable // progreStyle/inSupView
    
    static func showProgress(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDProgreContextable // barStyle/inSupView
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDProgreContextable // progreStyle/barStyle/inSupView
}

public protocol WisdomHUDSuccessable {
    
    static func showSuccess(text: String)->WisdomHUDContextable
    
    static func showSuccess(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

public protocol WisdomHUDErrorable {
    
    static func showError(text: String)->WisdomHUDContextable
    
    static func showError(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

public protocol WisdomHUDWarningable {
    
    static func showWarning(text: String)->WisdomHUDContextable
    
    static func showWarning(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

public protocol WisdomHUDTextCenterable {
    
    static func showTextCenter(text: String)->WisdomHUDContextable
    
    static func showTextCenter(text: String, inSupView: UIView?)->WisdomHUDContextable // inSupView
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable // barStyle
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?)->WisdomHUDContextable // barStyle/inSupView
    
    static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // inSupView/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/delays
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable // barStyle/inSupView/delays
}

public protocol WisdomHUDTextBottomable {
    
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
    
    func setProgressContent(text: String, progreStyle: WisdomProgreStyle, timeout: (TimeInterval, (TimeInterval)->())?)
    
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
    
    func setProgressImage(size: CGFloat, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle)
    
    func setSuccessImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setErrorImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setWarningImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool)
    
    func setDismissImage()
    
    func setProgreColor(color: UIColor)
    
    func setProgreValue(value: UInt)
    
    func setProgreTextColor(color: UIColor)
    
    func setProgreShadowColor(color: UIColor)
}

public protocol WisdomHUDActionable {
    
    static func showAction(title: String, text: String, leftAction: String?, rightAction: String, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable
    
    static func showAction(title: String, text: String, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable
    
    static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable

    static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, inSupView: UIView?, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable
}

public protocol WisdomHUDLogable {
    
    static func openLog()
    
    static func showLog(text: String)
    
    static func showLogSuccess(text: String)
    
    static func showLogWarning(text: String)
    
    static func showLogError(text: String)
}

@objc public protocol WisdomHUDBaseContextable {
    
    // Set the Context text size
    @discardableResult
    @objc func setTextFont(font: UIFont)->Self
    
    // Set the Context text color
    @discardableResult
    @objc func setTextColor(color: UIColor)->Self
    
    // Set the Context text new
    @discardableResult
    @objc func setUpdateText(text: String)->Self
    
    // Set the Context Animation view
    // * view: can't has superview, setting fail
    @discardableResult
    @objc func setAnimation(view: UIView)->Self
}

@objc public protocol WisdomHUDContextable: WisdomHUDBaseContextable {
    
    // Set the Context focusing. The underlying view interaction is not affected
    @discardableResult
    @objc func setFocusing()->Self
}

@objc public protocol WisdomHUDLoadingContextable: WisdomHUDBaseContextable {
    
    // Set the Loading Context timeout. The timeout callback is automatically removed
    @discardableResult
    @objc func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self
}

@objc public protocol WisdomHUDProgreContextable: WisdomHUDLoadingContextable {
    
    // Set the Progre Context Color. The progress bar color
    @discardableResult
    @objc func setProgreColor(color: UIColor)->Self
    
    // Set the Progre Context task value.
    @discardableResult
    @objc func setProgreValue(value: UInt)->Self
    
    // Set the Progre Context text color.
    @discardableResult
    @objc func setProgreTextColor(color: UIColor)->Self
    
    // Set the Progre Context shadow color.
    @discardableResult
    @objc func setProgreShadowColor(color: UIColor)->Self
}

@objc public protocol WisdomHUDActionContextable {
    
    // Set the Action Context Left Text UIColor/UIFont
    @discardableResult
    @objc func setLeftAction(textColor: UIColor?, textFont: UIFont?)->Self
    
    // Set the Action Context Right Text UIColor/UIFont
    @discardableResult
    @objc func setRightAction(textColor: UIColor?, textFont: UIFont?)->Self
    
    // Set the Action Context Text UIFont
    @discardableResult
    @objc func setTextFont(font: UIFont)->Self
    
    // Set the Action Context Text UIColor
    @discardableResult
    @objc func setTextColor(color: UIColor)->Self
    
    // Set the Action Context Text NSTextAlignment
    @discardableResult
    @objc func setTextAlignment(alignment: NSTextAlignment)->Self
    
    // Set the Action Context Label UIFont
    @discardableResult
    @objc func setLabelFont(font: UIFont)->Self
    
    // Set the Action Context Label UIColor
    @discardableResult
    @objc func setLabelColor(color: UIColor)->Self
}
