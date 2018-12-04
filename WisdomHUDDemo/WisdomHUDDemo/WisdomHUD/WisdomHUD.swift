//
//  WisdomHUD.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/3.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

public class WisdomHUD: NSObject {
    
    fileprivate var wisdomLayerView: WisdomLayerView?
    
    public static let shared: WisdomHUD = WisdomHUD()
    
    var coverBarStyle: WisdomCoverBarStyle = .dark

}


extension WisdomHUD {
    
    /**  1.成功提示
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showSuccess(text: String?)-> WisdomLayerView {
        return WisdomLayerView.showSuccess(text: text, delay: delayTime, enable: false)
    }
    
    
    /**  2.成功提示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showSuccess(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        return WisdomLayerView.showSuccess(text: text, delay: delay, enable: enable)
    }
    
    
    /**  3.失败提示
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showError(text: String?)-> WisdomLayerView {
        return WisdomLayerView.showError(text: text, delay: delayTime, enable: false)
    }
    
    
    /**  4.失败提示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showError(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        return WisdomLayerView.showError(text: text, delay: delay, enable: enable)
    }
    
    
    /**  5.警告信息提示展示
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showInfo(text: String?)-> WisdomLayerView {
        return WisdomLayerView.showInfo(text: text, delay: delayTime, enable: false)
    }
    
    
    /**  6.警告信息提示展示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showInfo(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        return WisdomLayerView.showInfo(text: text, delay: delay, enable: enable)
    }
    
    
    /**  7.耗时加载
     *   无文字Loading
     *   默认不可交互(全屏遮罩)
     */
    @objc public static func showLoading() {
        WisdomLayerView.showLoading(text: nil, enable: false)
    }
    
    
    /**  8.耗时加载
     *   text:   Loading文字
     *   enable: 是否全屏遮罩
     */
    @objc public static func showLoading(text: String?, enable: Bool = false) {
        WisdomLayerView.showLoading(text: text, enable: enable)
    }
    
    
    /**  9.无图片信息提示展示，纯文字
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showText(text: String?)-> WisdomLayerView {
        return WisdomLayerView.showText(text: text, delay: delayTime, enable: false)
    }
    
    
    /**  10.无图片信息提示展示，纯文字
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showText(text: String?, delay: TimeInterval, enable: Bool = false)-> WisdomLayerView {
        return WisdomLayerView.showText(text: text, delay: delay, enable: enable)
    }

    
    /**  11.dismiss() 移除屏幕展示 */
    @objc public func dismiss() {
        wisdomLayerView?.hide()
    }
    
    
    /** 12.Hide func 延迟移除屏幕展示 */
    @objc public func dismiss(delay: TimeInterval = delayTime) {
        wisdomLayerView?.hide(delay: delay)
    }
    
    
    /** 13.类方法
     *  Hide func 移除屏幕展示
     */
    @objc public static func dismiss() {
        WisdomLayerView.hide()
    }
    
    
    /** 14.类方法
     *  Hide func 延迟移除屏幕展示
     */
    @objc public static func dismiss(delay: TimeInterval = delayTime) {
        WisdomLayerView.hide(delay: delay)
    }
}
