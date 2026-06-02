//
//  HUD.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/3.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//
//  跨平台公共门面。所有 show* / setting / log API 都在这里。
//  iOS/tvOS 转发到 WisdomHUDCore;macOS 转发到 WisdomHUDMacCore。
//
//  注:macOS 端 WisdomHUDMacCore 是 @MainActor,因此 macOS 上 WisdomHUD 类也要 @MainActor;
//      iOS/tvOS WisdomHUDCore 是 nonisolated 普通 struct,WisdomHUD 类无需隔离。
//
//  结构:
//   - 方法实现:统一放在 non-conforming 的 `extension WisdomHUD { }` 块里。
//   - 协议 conformance:抽到文件末尾 #if 分平台声明,
//     macOS 那份带 @MainActor 修饰以避免 conformance-isolation 警告。
//

#if os(iOS) || os(tvOS) || os(macOS)

#if os(iOS) || os(tvOS)
import UIKit
internal typealias WisdomHUDCoreImpl = WisdomHUDCore
#elseif os(macOS)
import AppKit
internal typealias WisdomHUDCoreImpl = WisdomHUDMacCore
#endif


// 类声明:macOS 必须 @MainActor 才能调用 @MainActor Core;iOS 保持 nonisolated。
#if os(iOS) || os(tvOS)
@objc public final class WisdomHUD: NSObject {
    @available(*, unavailable)
    override init() {
        
    }
}
#elseif os(macOS)
@objc @MainActor public final class WisdomHUD: NSObject {
    @available(*, unavailable)
    override init() {
        
    }
}
#endif


// MARK: - Settingable 设置配置
extension WisdomHUD: WisdomHUDSettingable {
    
    // MARK: HUD Set Loading Style
    @objc public static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        WisdomHUDCoreImpl.setLoadingStyle(loadingStyle: loadingStyle)
    }
    
    // MARK: HUD Set Progress Style
    @objc public static func setProgressStyle(progreStyle: WisdomProgreStyle) {
        WisdomHUDCoreImpl.setProgressStyle(progreStyle: progreStyle)
    }
    
    // MARK: HUD Set Scene Bar Style
    @objc public static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle) {
        WisdomHUDCoreImpl.setSceneBarStyle(sceneBarStyle: sceneBarStyle)
    }
    
    // MARK: HUD Set Scene Custom Color
    @objc public static func setSceneBarCustomColor(color: WisdomHUDColor?) {
        WisdomHUDCoreImpl.setSceneBarCustomColor(color: color)
    }
    
    // MARK: HUD Set Text MaxLines
    @objc public static func setTextMaxLines(maxLine: WisdomTextMaxLineStyle) {
        WisdomHUDCoreImpl.setTextMaxLines(maxLine: maxLine)
    }
    
    // MARK: HUD Set Display Delay
    @objc public static func setDisplayDelay(delayTime: CGFloat) {
        WisdomHUDCoreImpl.setDisplayDelay(delayTime: delayTime)
    }
    
    // MARK: HUD Set Cover BackgColor
    @objc public static func setCoverBackgColor(backgColor: WisdomHUDColor) {
        WisdomHUDCoreImpl.setCoverBackgColor(backgColor: backgColor)
    }
    
    // MARK: 全局设置 文字文案 大小（会被自定义覆盖）
    @objc public static func setTextSizeStyle(textSizeStyle: WisdomTextSizeStyle) {
        WisdomHUDCoreImpl.setTextSizeStyle(textSizeStyle: textSizeStyle)
    }
}


// MARK: - Globalable 操控
extension WisdomHUD: WisdomHUDGlobalable {
    
    // MARK: HUD dismiss
    @objc public static func dismiss() {
        WisdomHUDCoreImpl.dismiss()
    }
    
    // MARK: HUD dismiss Action
    @objc public static func dismissAction() {
        WisdomHUDCoreImpl.dismissAction()
    }
    
    // MARK: Get UIApplication UIWindow
    @objc public static func getScreenWindow() -> WisdomHUDWindow? {
        return WisdomHUDCoreImpl.getScreenWindow()
    }
    
    // MARK: Small Screen For Example: iPhone 8, iPhone 7, iPhone 6 and the following
    @objc public static func isSmallScreen() -> Bool {
        return WisdomHUDCoreImpl.isSmallScreen()
    }
}


// MARK: - Loadingable 开始提示
extension WisdomHUD: WisdomHUDLoadingable {
    
    // MARK: Show Loading with: String
    @discardableResult
    @objc public static func showLoading(text: String)->WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text)
    }
    
    // MARK: Show Loading with: String - UIView?
    @discardableResult
    @objc public static func showLoading(text: String, inSupView: WisdomHUDView?) -> WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Loading with: String - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showLoading(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle
    @discardableResult
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle)->WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text, loadingStyle: loadingStyle)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle)->WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text, loadingStyle: loadingStyle, barStyle: barStyle)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle - UIView?
    @discardableResult
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: WisdomHUDView?)->WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text, loadingStyle: loadingStyle, inSupView: inSupView)
    }
    
    // MARK: Show Loading with: String - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Loading with: String - WisdomLoadingStyle - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDLoadingContextable {
        return WisdomHUDCoreImpl.showLoading(text: text, loadingStyle: loadingStyle, barStyle: barStyle, inSupView: inSupView)
    }
}


// MARK: - Progreable  进度提示
extension WisdomHUD: WisdomHUDProgreable {
    
    // MARK: Show Progress with: String
    @discardableResult
    @objc public static func showProgress(text: String) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text)
    }
    
    // MARK: Show Progress with: String - UIView?
    @discardableResult
    @objc public static func showProgress(text: String, inSupView: WisdomHUDView?) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Progress with: String - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showProgress(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Progress with: String - WisdomProgreStyle
    @discardableResult
    @objc public static func showProgress(text: String, progreStyle: WisdomProgreStyle) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text, progreStyle: progreStyle)
    }
    
    // MARK: Show Progress with: String - WisdomProgreStyle - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showProgress(text: String, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text, progreStyle: progreStyle, barStyle: barStyle)
    }
    
    // MARK: Show Progress with: String - WisdomProgreStyle - UIView?
    @discardableResult
    @objc public static func showProgress(text: String, progreStyle: WisdomProgreStyle, inSupView: WisdomHUDView?) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text, progreStyle: progreStyle, inSupView: inSupView)
    }
    
    // MARK: Show Progress with: String - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showProgress(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Progress with: String - WisdomProgreStyle - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showProgress(text: String, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDProgreContextable {
        return WisdomHUDCoreImpl.showProgress(text: text, progreStyle: progreStyle, barStyle: barStyle, inSupView: inSupView)
    }
}


// MARK: - Successable  成功提示
extension WisdomHUD: WisdomHUDSuccessable {
    
    // MARK: Show Success with: String
    @discardableResult
    @objc public static func showSuccess(text: String) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text)
    }
    
    // MARK: Show Success with: String - UIView?
    @discardableResult
    @objc public static func showSuccess(text: String, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Success with: String - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Success with: String - UIView? -TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showSuccess(text: String, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Success with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showSuccess(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


// MARK: - Errorable  错误提示
extension WisdomHUD: WisdomHUDErrorable {
    
    // MARK: Show Error with: String
    @discardableResult
    @objc public static func showError(text: String) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text)
    }
    
    // MARK: Show Error with: String - UIView?
    @discardableResult
    @objc public static func showError(text: String, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Error with: String - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Error with: String - UIView? -TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showError(text: String, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Error with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showError(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


// MARK: - Warningable  警告提示
extension WisdomHUD: WisdomHUDWarningable {
    
    // MARK: Show Warning with: String
    @discardableResult
    @objc public static func showWarning(text: String)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text)
    }
    
    // MARK: Show Warning with: String - UIView?
    @discardableResult
    @objc public static func showWarning(text: String, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Warning with: String - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Warning with: String - UIView? -TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showWarning(text: String, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Warning with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showWarning(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


// MARK: - TextCenterable  文字中心提示
extension WisdomHUD: WisdomHUDTextCenterable {
    
    // MARK: Show Text Center with: String
    @discardableResult
    @objc public static func showTextCenter(text: String)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text)
    }
    
    // MARK: Show Text Center with: String - UIView?
    @discardableResult
    @objc public static func showTextCenter(text: String, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Text Center with: String - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Text Center with: String - UIView? -TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextCenter(text: String, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Center with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


// MARK: - TextBottomable  文字底部提示
extension WisdomHUD: WisdomHUDTextBottomable {
    
    // MARK: Show Text Bottom with: String
    @discardableResult
    @objc public static func showTextBottom(text: String)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text)
    }
    
    // MARK: Show Text Bottom with: String - UIView?
    @discardableResult
    @objc public static func showTextBottom(text: String, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text, inSupView: inSupView)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle
    @discardableResult
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text, barStyle: barStyle)
    }
    
    // MARK: Show Text Bottom with: String - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle - UIView?
    @discardableResult
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView)
    }
    
    // MARK: Show Text Bottom with: String - UIView? -TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextBottom(text: String, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?)->WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text, barStyle: barStyle, delays: delays, delayClosure: delayClosure)
    }
    
    // MARK: Show Text Bottom with: String - WisdomSceneBarStyle - UIView? - TimeInterval - ((TimeInterval)->())?
    @discardableResult
    @objc public static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: WisdomHUDView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDContextable {
        return WisdomHUDCoreImpl.showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


// MARK: - Actionable  选择事件提示
extension WisdomHUD: WisdomHUDActionable {
    
    // MARK: Show Action
    // title/text            : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, leftAction: String?, rightAction: String, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable{
        return WisdomHUDCoreImpl.showAction(title: title, text: text, leftAction: leftAction, rightAction: rightAction, actionClosure: actionClosure)
    }
    
    // MARK: Show Action
    // title/text            : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // themeStyle            : UIColor's theme
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable{
        return WisdomHUDCoreImpl.showAction(title: title, text: text, leftAction: leftAction, rightAction: rightAction, themeStyle: themeStyle, actionClosure: actionClosure)
    }
    
    // MARK: Show Action
    // title/text/label      : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // themeStyle            : UIColor's theme
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable{
        return WisdomHUDCoreImpl.showAction(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, themeStyle: themeStyle, actionClosure: actionClosure)
    }
    
    // MARK: Show Action
    // title/text/label      : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // themeStyle            : UIColor's theme
    // inSupView             : UIView's supView
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, inSupView: WisdomHUDView?, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool))->WisdomHUDActionContextable{
        return WisdomHUDCoreImpl.showAction(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, themeStyle: themeStyle, inSupView: inSupView, actionClosure: actionClosure)
    }
}


// MARK: - Logable  日志界面提示
extension WisdomHUD: WisdomHUDLogable {
    
    // MARK: Debug Open Log 
    @objc public static func openLog() {
        WisdomHUDCoreImpl.openLog()
    }
    
    // MARK: Debug Show Log with: String
    @objc public static func showLog(text: String) {
        WisdomHUDCoreImpl.showLog(text: text)
    }
    
    // MARK: Debug Show Log Success with: String
    @objc public static func showLogSuccess(text: String) {
        WisdomHUDCoreImpl.showLogSuccess(text: text)
    }
    
    // MARK: Debug Show Log Warning with: String
    @objc public static func showLogWarning(text: String) {
        WisdomHUDCoreImpl.showLogWarning(text: text)
    }
    
    // MARK: Debug Show Log Error with: String
    @objc public static func showLogError(text: String) {
        WisdomHUDCoreImpl.showLogError(text: text)
    }
    
    // MARK: Debug Show Log Label with: String
    @objc public static func showLogLabel(text: String) {
        WisdomHUDCoreImpl.showLogLabel(text: text)
    }
}

#endif // os(iOS) || os(tvOS) || os(macOS)
