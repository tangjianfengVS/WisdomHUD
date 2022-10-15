//
//  WisdomHUD.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/3.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit


@objc public final class WisdomHUD: NSObject {
    
    @available(*, unavailable)
    override init() {}
}

extension WisdomHUD: WisdomHUDSettingable {
    
    // MARK: HUD Set Loading Style
    @objc static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        WisdomHUDOperate.setLoadingStyle(loadingStyle: loadingStyle)
    }
    
    // MARK: HUD Set Scene Bar Style
    @objc static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.setSceneBarStyle(sceneBarStyle: sceneBarStyle)
    }
    
    // MARK: HUD Set Text Place Style
    @objc static func setTextPlaceStyle(textStyle: WisdomTextPlaceStyle) {
        WisdomHUDOperate.setTextPlaceStyle(textStyle: textStyle)
    }
    
    // MARK: HUD Set Display Delay
    @objc static func setDisplayDelay(delayTime: CGFloat) {
        WisdomHUDOperate.setDisplayDelay(delayTime: delayTime)
    }
    
    // MARK: HUD Set Cover BackgColor
    @objc static func setCoverBackgColor(backgColor: UIColor) {
        WisdomHUDOperate.setCoverBackgColor(backgColor: backgColor)
    }
}

extension WisdomHUD: WisdomHUDGlobalable {
    
    // MARK: HUD dismiss
    @objc public static func dismiss() {
        WisdomHUDOperate.dismiss()
    }
    
    // MARK: Get UIApplication UIWindow
    @objc public static func getScreenWindow() -> UIWindow? {
        return WisdomHUDOperate.getScreenWindow()
    }
    
    // MARK: Small Screen For Example: iPhone 8, iPhone 7, iPhone 6 and the following
    static func isSmallScreen() -> Bool {
        return WisdomHUDOperate.isSmallScreen()
    }
}

extension WisdomHUD: WisdomHUDLoadingable {
    
    // MARK: Show Loading with: String
    @objc public static func showLoading(text: String) {
        WisdomHUDOperate.showLoading(text: text)
    }
    
    // MARK: Show Loading with: String - UIView?
    @objc public static func showLoading(text: String, inSupView: UIView?) {
        WisdomHUDOperate.showLoading(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Loading with: String - WisdomSceneBarStyle
    @objc public static func showLoading(text: String, barStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.showLoading(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle) {
        WisdomHUDOperate.showLoading(text: text, loadingStyle: loadingStyle)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle - WisdomSceneBarStyle
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.showLoading(text: text, loadingStyle: loadingStyle, barStyle: barStyle)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle - UIView?
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: UIView?) {
        WisdomHUDOperate.showLoading(text: text, loadingStyle: loadingStyle, inSupView: inSupView)
    }
    
    // MARK: Show Loading with: String - WisdomSceneBarStyle - UIView?
    @objc public static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        WisdomHUDOperate.showLoading(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle - WisdomSceneBarStyle - UIView?
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        WisdomHUDOperate.showLoading(text: text, loadingStyle: loadingStyle, barStyle: barStyle, inSupView: inSupView)
    }
}

extension WisdomHUD: WisdomHUDSuccessable {
    
    // MARK: Show Success with: String
    @objc public static func showSuccess(text: String) {
        WisdomHUDOperate.showSuccess(text: text)
    }
    
    // MARK: Show Success with: String - UIView?
    @objc public static func showSuccess(text: String, inSupView: UIView?) {
        WisdomHUDOperate.showSuccess(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.showSuccess(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Success with: String - TimeInterval - ((TimeInterval)->())?
    @objc public static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showSuccess(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle - UIView?
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        WisdomHUDOperate.showSuccess(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Success with: String - UIView? -TimeInterval - ((TimeInterval)->())? -
    @objc public static func showSuccess(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showSuccess(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        WisdomHUDOperate.showSuccess(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showSuccess(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}

extension WisdomHUD: WisdomHUDErrorable {
    
    // MARK: Show Error with: String
    @objc public static func showError(text: String) {
        WisdomHUDOperate.showError(text: text)
    }
    
    // MARK: Show Error with: String - UIView?
    @objc public static func showError(text: String, inSupView: UIView?) {
        WisdomHUDOperate.showError(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.showError(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Error with: String - TimeInterval - ((TimeInterval)->())?
    @objc public static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showError(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle - UIView?
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        WisdomHUDOperate.showError(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Error with: String - UIView? -TimeInterval - ((TimeInterval)->())? -
    @objc public static func showError(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showError(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        WisdomHUDOperate.showError(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showError(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}

extension WisdomHUD: WisdomHUDWarningable {
    
    // MARK: Show Warning with: String
    @objc public static func showWarning(text: String) {
        WisdomHUDOperate.showWarning(text: text)
    }
    
    // MARK: Show Warning with: String - UIView?
    @objc public static func showWarning(text: String, inSupView: UIView?) {
        WisdomHUDOperate.showWarning(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.showWarning(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Warning with: String - TimeInterval - ((TimeInterval)->())?
    @objc public static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showWarning(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle - UIView?
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        WisdomHUDOperate.showWarning(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Warning with: String - UIView? -TimeInterval - ((TimeInterval)->())? -
    @objc public static func showWarning(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showWarning(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        WisdomHUDOperate.showWarning(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showWarning(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}

extension WisdomHUD: WisdomHUDTextCenterable {
    
    // MARK: Show Text Center with: String
    @objc public static func showTextCenter(text: String) {
        WisdomHUDOperate.showTextCenter(text: text)
    }
    
    // MARK: Show Text Center with: String - UIView?
    @objc public static func showTextCenter(text: String, inSupView: UIView?) {
        WisdomHUDOperate.showTextCenter(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.showTextCenter(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Text Center with: String - TimeInterval - ((TimeInterval)->())?
    @objc public static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showTextCenter(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle - UIView?
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        WisdomHUDOperate.showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Text Center with: String - UIView? -TimeInterval - ((TimeInterval)->())? -
    @objc public static func showTextCenter(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showTextCenter(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        WisdomHUDOperate.showTextCenter(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}

extension WisdomHUD: WisdomHUDTextBottomable {
    
    // MARK: Show Text Bottom with: String
    @objc public static func showTextBottom(text: String) {
        WisdomHUDOperate.showTextBottom(text: text)
    }
    
    // MARK: Show Text Bottom with: String - UIView?
    @objc public static func showTextBottom(text: String, inSupView: UIView?) {
        WisdomHUDOperate.showTextBottom(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle) {
        WisdomHUDOperate.showTextBottom(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Text Bottom with: String - TimeInterval - ((TimeInterval)->())?
    @objc public static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showTextBottom(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle - UIView?
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?) {
        WisdomHUDOperate.showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Text Bottom with: String - UIView? -TimeInterval - ((TimeInterval)->())? -
    @objc public static func showTextBottom(text: String, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showTextBottom(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        WisdomHUDOperate.showTextBottom(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: UIView?, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        WisdomHUDOperate.showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}
