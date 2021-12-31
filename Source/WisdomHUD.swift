//
//  WisdomHUD.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/3.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit


// MARK: - WisdomHUD 全局 遮罩颜色类型
public private(set) var wisdomCoverBarStyle: WisdomCoverBarStyle = .dark

// MARK: - WisdomHUD 全局 显示时长
public private(set) var wisdomDelayTimes: TimeInterval = 2.0

// MARK: - WisdomHUD 全局 Loading类型
public private(set) var wisdomLoadingStyle: WisdomLoadingStyle = .rotate



@objc public class WisdomHUD: NSObject {
    
    // MARK: - 更新 WisdomHUD 全局 遮罩颜色类型
    @objc public static func setCoverBarStyle(coverBarStyle: WisdomCoverBarStyle) {
        wisdomCoverBarStyle = coverBarStyle
    }
    
    
    // MARK: - WisdomHUD 全局 显示时长
    @objc public static func setHUDDelayTime(delayTimes: CGFloat) {
        wisdomDelayTimes = TimeInterval.init(delayTimes)
    }
    
    
    // MARK: - 更新 WisdomHUD 全局 Loading类型
    @objc public static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        wisdomLoadingStyle = loadingStyle
    }
}


extension WisdomHUD {
    
    // MARK: --------------- Success ---------------

    /*  WisdomHUD Success */
    @objc public static func showSuccess(text: String?=nil) {
        WisdomHUD.showSuccess(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Success
     *  text:      文字
     *  delay:     持续时间
     *  barStyle:  HUD样式
     *  delayHandler:  HUD延迟结束回调
     */
    @objc public static func showSuccess(text: String?=nil,
                                         textColor: UIColor?=nil,
                                         delay: TimeInterval=wisdomDelayTimes,
                                         barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle,
                                         delayHandler: ((TimeInterval, WisdomHUDType)->())?=nil) {
        WisdomLayerView.showSuccess(text: text,
                                    textColor: textColor,
                                    delay: delay,
                                    barStyle: barStyle,
                                    delayHandler: delayHandler)
    }
    
    
    // MARK: --------------- Error ---------------
    
    /*  WisdomHUD Error */
    @objc public static func showError(text: String?=nil) {
        WisdomHUD.showError(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Error
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     *  delayHandler:  HUD延迟结束回调
     */
    @objc public static func showError(text: String?=nil,
                                       textColor: UIColor?=nil,
                                       delay: TimeInterval=wisdomDelayTimes,
                                       barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle,
                                       delayHandler: ((TimeInterval, WisdomHUDType)->())?=nil) {
        WisdomLayerView.showError(text: text,
                                  textColor: textColor,
                                  delay: delay,
                                  barStyle: barStyle,
                                  delayHandler: delayHandler)
    }
    
    
    // MARK: --------------- Warning ---------------
    
    /*  WisdomHUD Warning */
    @objc public static func showWarning(text: String?=nil) {
        WisdomHUD.showWarning(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Warning
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     *  delayHandler:  HUD延迟结束回调
     */
    @objc public static func showWarning(text: String?=nil,
                                         textColor: UIColor?=nil,
                                         delay: TimeInterval=wisdomDelayTimes,
                                         barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle,
                                         delayHandler: ((TimeInterval, WisdomHUDType)->())?=nil) {
        WisdomLayerView.showWarning(text: text,
                                    textColor: textColor,
                                    delay: delay,
                                    barStyle: barStyle,
                                    delayHandler: delayHandler)
    }
    
    
    // MARK: --------------- Loading ---------------
    
    /*  WisdomHUD Loading */
    @objc public static func showLoading(text: String?=nil) {
        WisdomHUD.showLoading(text: text, loadingStyle: wisdomLoadingStyle)
    }
    
    
    /*  WisdomHUD Loading
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     *  loadingStyle: 加载样式
     */
    @objc public static func showLoading(text: String?=nil,
                                         textColor: UIColor?=nil,
                                         barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle,
                                         loadingStyle: WisdomLoadingStyle=wisdomLoadingStyle) {
        WisdomLayerView.showLoading(text: text,
                                    textColor: textColor,
                                    barStyle: barStyle,
                                    loadingStyle: loadingStyle)
    }
    

    // MARK: --------------- Text ---------------
    
    /*  WisdomHUD Text */
    @objc public static func showText(text: String?=nil) {
        WisdomHUD.showText(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Text
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     *  delayHandler:  HUD延迟结束回调
     */
    @objc public static func showText(text: String?=nil,
                                      textColor: UIColor?=nil,
                                      delay: TimeInterval=wisdomDelayTimes,
                                      barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle,
                                      delayHandler: ((TimeInterval, WisdomHUDType)->())?=nil) {
        WisdomLayerView.showText(text: text,
                                 textColor: textColor,
                                 delay: delay,
                                 barStyle: barStyle,
                                 delayHandler: delayHandler)
    }
    
    
    // MARK: --------------- TextRoot ---------------
    
    /*  WisdomHUD TextRoot */
    @objc public static func showTextRoot(text: String?=nil) {
        WisdomHUD.showTextRoot(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD TextRoot
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     *  delayHandler:  HUD延迟结束回调
     */
    @objc public static func showTextRoot(text: String?=nil,
                                          textColor: UIColor?=nil,
                                          delay: TimeInterval=wisdomDelayTimes,
                                          barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle,
                                          delayHandler: ((TimeInterval, WisdomHUDType)->())?=nil) {
        WisdomLayerView.showTextRoot(text: text,
                                     textColor: textColor,
                                     delay: delay,
                                     barStyle: barStyle,
                                     delayHandler: delayHandler)
    }
    
    
    // MARK: --------------- Action ---------------
    
    /*  WisdomHUD ActionView
     *  title        :   标题
     *  infoText     :   详情
     *  tailText     :   标签
     *  actionList   :   选项集合
     *  themeStyle   :   视图主题
     *  actionHandler:   选项事件
     */
    @objc public static func showAction(title: String,
                                        infoText: String,
                                        tailText: String,
                                        actionList: [String],
                                        themeStyle: WisdomLayerThemeStyle=WisdomLayerThemeStyle.snowWhite,
                                        actionHandler: @escaping (String, NSInteger)->()) {
        WisdomActionView.showAction(title: title,
                                    infoText: infoText,
                                    tailText: tailText,
                                    actionList: actionList,
                                    themeStyle: themeStyle,
                                    actionHandler: actionHandler)
    }
    
    
    
    // MARK: --------------- ColorView ---------------
    
    /*  WisdomHUD ColorView
     *  text:
     *  textColor:
     *  delay:
     *  barStyle:
     *  delayHandler:
     */
    @objc public static func createColorView(width: CGFloat, height: CGFloat=30, color: UIColor) -> UIView{
        
        return WisdomLayerCoverView.createColorLayerView(width: width, height: height, color: color)
    }
    

    // MARK: - 移除 HUD
    @objc public static func dismiss() {
        DispatchQueue.main.async {
            let window = WisdomHUD.getScreenWindow()
            let currentView = window?.viewWithTag(WisdomHUDWindowTag)
            
            if let hudCoverVI = currentView as? WisdomLayerCoverView {
                // 添加动画，会影响
                //UIView.animate(withDuration: 0.40, animations: {
                //    hudCoverVI.alpha = 0
                //}) { _ in
                hudCoverVI.removeFromSuperview()
                //}
            }
        }
    }
    
    
    // MARK: - 获取 UIApplication UIWindow
    @objc static func getScreenWindow() -> UIWindow? {
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

}
