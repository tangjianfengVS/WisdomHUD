//
//  WisdomHUD.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/3.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

/* WisdomHUD 遮罩颜色类型 */
public private(set) var wisdomCoverBarStyle: WisdomCoverBarStyle = .dark

/* WisdomHUD 显示时长 */
public private(set) var wisdomDelayTimes: TimeInterval = 2.0

/* WisdomHUD Loading类型 */
public private(set) var wisdomLoadingStyle: WisdomLoadingStyle = .rotate


@objc public class WisdomHUD: NSObject {
    
    /* 更新 WisdomHUD 遮罩颜色类型 */
    @objc public static func setCoverBarStyle(coverBarStyle: WisdomCoverBarStyle) {
        wisdomCoverBarStyle = coverBarStyle
    }
    
    
    /* 更新 WisdomHUD 显示时长 */
    @objc public static func setHUDDelayTime(delayTimes: CGFloat) {
        wisdomDelayTimes = TimeInterval(delayTimes)
    }
    
    
    /* 更新 WisdomHUD Loading类型 */
    @objc public static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        wisdomLoadingStyle = loadingStyle
    }
}


extension WisdomHUD {
    
    /* ------------------------- Success ------------------------- */

    /*  WisdomHUD Success */
    @discardableResult
    @objc public static func showSuccess(text: String?=nil)-> WisdomLayerView {
        return WisdomHUD.showSuccess(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Success
     *  text:      文字
     *  delay:     持续时间
     *  barStyle:  HUD样式
     */
    @discardableResult
    @objc public static func showSuccess(text: String?=nil,
                                         textColor: UIColor?=nil,
                                         delay: TimeInterval=wisdomDelayTimes,
                                         barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView.showSuccess(text: text,
                                                    textColor: textColor,
                                                    delay: delay,
                                                    barStyle: barStyle)
        return layerView
    }
    
    
    /* ------------------------- Error ------------------------- */
    
    /*  WisdomHUD Error */
    @discardableResult
    @objc public static func showError(text: String?=nil)-> WisdomLayerView {
        return WisdomHUD.showError(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Error
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     */
    @discardableResult
    @objc public static func showError(text: String?=nil,
                                       textColor: UIColor?=nil,
                                       delay: TimeInterval=wisdomDelayTimes,
                                       barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView.showError(text: text,
                                                  textColor: textColor,
                                                  delay: delay,
                                                  barStyle: barStyle)
        return layerView
    }
    
    
    /* ------------------------- Warning ------------------------- */
    
    /*  WisdomHUD Warning */
    @discardableResult
    @objc public static func showWarning(text: String?=nil)-> WisdomLayerView {
        return WisdomHUD.showWarning(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Warning
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     */
    @discardableResult
    @objc public static func showWarning(text: String?=nil,
                                         textColor: UIColor?=nil,
                                         delay: TimeInterval=wisdomDelayTimes,
                                         barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView.showWarning(text: text,
                                                    textColor: textColor,
                                                    delay: delay,
                                                    barStyle: barStyle)
        return layerView
    }
    
    
    /* ------------------------- Loading ------------------------- */
    
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
    

    /* ------------------------- Text ------------------------- */
    
    /*  WisdomHUD Text */
    @discardableResult
    @objc public static func showText(text: String?=nil)-> WisdomLayerView {
        return WisdomHUD.showText(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD Text
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     */
    @discardableResult
    @objc public static func showText(text: String?=nil,
                                      textColor: UIColor?=nil,
                                      delay: TimeInterval=wisdomDelayTimes,
                                      barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView.showText(text: text,
                                                 textColor: textColor,
                                                 delay: delay,
                                                 barStyle: barStyle)
        return layerView
    }
    
    
    /* ------------------------- TextRoot ------------------------- */
    
    /*  WisdomHUD TextRoot */
    @discardableResult
    @objc public static func showTextRoot(text: String?=nil)-> WisdomLayerView {
        return WisdomHUD.showTextRoot(text: text, delay: wisdomDelayTimes)
    }
    
    
    /*  WisdomHUD TextRoot
     *  text:      文字
     *  textColor: 文字颜色
     *  delay:     持续时间
     *  barStyle:  HUD样式
     */
    @discardableResult
    @objc public static func showTextRoot(text: String?=nil,
                                          textColor: UIColor?=nil,
                                          delay: TimeInterval=wisdomDelayTimes,
                                          barStyle: WisdomCoverBarStyle=wisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView.showTextRoot(text: text,
                                                     textColor: textColor,
                                                     delay: delay,
                                                     barStyle: barStyle)
        return layerView
    }


    /* 移除 HUD */
    @objc public static func dismiss() {
        let window = UIApplication.shared.keyWindow
        let currentView = window?.viewWithTag(WisdomHUDWindowTag)
        
        if let hudCoverVI = currentView as? WisdomLayerCoverView {
            hudCoverVI.removeFromSuperview()
        }
    }

}
