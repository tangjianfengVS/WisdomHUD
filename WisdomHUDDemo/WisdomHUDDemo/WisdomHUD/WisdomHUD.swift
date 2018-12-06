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
    
    @objc public static let shared: WisdomHUD = WisdomHUD()
    
    /** HUD遮罩颜色类型 */
    @objc public var coverBarStyle: WisdomCoverBarStyle = .dark
    
    /** HUD指示Loading类型 */
    @objc public var loadingStyle: WisdomLoadingStyle = .system
    
    /** 重置wisdomLayerView */
    fileprivate func updateHUD(layerView: WisdomLayerView) {
        wisdomLayerView?.removeFromSuperview()
        wisdomLayerView?.screenView.removeFromSuperview()
        wisdomLayerView = layerView
    }
}


extension WisdomHUD {
    
    /**  1.成功提示
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showSuccess(text: String?)-> WisdomLayerView {
        let layerView = WisdomLayerView.showSuccess(text: text, delay: delayTime, enable: false)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }
    
    
    /**  2.成功提示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showSuccess(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        let layerView = WisdomLayerView.showSuccess(text: text, delay: delay, enable: enable)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }
    
    
    /**  3.失败提示
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showError(text: String?)-> WisdomLayerView {
        let layerView = WisdomLayerView.showError(text: text, delay: delayTime, enable: false)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }
    
    
    /**  4.失败提示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showError(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        let layerView = WisdomLayerView.showError(text: text, delay: delay, enable: enable)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }
    
    
    /**  5.警告信息提示展示
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showInfo(text: String?)-> WisdomLayerView {
        let layerView = WisdomLayerView.showInfo(text: text, delay: delayTime, enable: false)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }
    
    
    /**  6.警告信息提示展示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showInfo(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        let layerView = WisdomLayerView.showInfo(text: text, delay: delay, enable: enable)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }
    
    
    /**  7.耗时加载
     *   无文字Loading
     *   默认不可交互(全屏遮罩)
     */
    @objc public static func showLoading() {
        let layerView = WisdomLayerView.showLoading(text: nil, enable: false)
        WisdomHUD.shared.updateHUD(layerView: layerView)
    }
    
    
    /**  8.耗时加载
     *   text:   Loading文字
     *   默认不可交互(全屏遮罩)
     */
    @objc public static func showLoading(text: String?) {
        let layerView = WisdomLayerView.showLoading(text: text, enable: false)
        WisdomHUD.shared.updateHUD(layerView: layerView)
    }
    
    
    /**  9.耗时加载
     *   text:   Loading文字
     *   enable: 是否全屏遮罩
     */
    @objc public static func showLoading(text: String?, enable: Bool = false) {
        let layerView = WisdomLayerView.showLoading(text: text, enable: enable)
        WisdomHUD.shared.updateHUD(layerView: layerView)
    }
    
    
    /**  10.无图片信息提示展示，纯文字
     *   text:   文字
     *   默认时间，默认不可交互(全屏遮罩)
     */
    @discardableResult
    @objc public static func showText(text: String?)-> WisdomLayerView {
        let layerView = WisdomLayerView.showText(text: text, delay: delayTime, enable: false)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }
    
    
    /**  11.无图片信息提示展示，纯文字
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    @discardableResult
    @objc public static func showText(text: String?, delay: TimeInterval, enable: Bool = false)-> WisdomLayerView {
        let layerView = WisdomLayerView.showText(text: text, delay: delay, enable: enable)
        WisdomHUD.shared.updateHUD(layerView: layerView)
        return layerView
    }

    
    /**  12.dismiss() 移除屏幕展示 */
    @objc public func dismiss() {
        wisdomLayerView?.hide()
    }
    
    
    /** 13.Hide func 延迟移除屏幕展示 */
    @objc public func dismiss(delay: TimeInterval = delayTime) {
        wisdomLayerView?.hide(delay: delay)
    }
    
    
    /** 14.类方法
     *  Hide func 移除屏幕展示
     */
    @objc public static func dismiss() {
        WisdomHUD.shared.wisdomLayerView?.hide()
    }
    
    
    /** 15.类方法
     *  Hide func 延迟移除屏幕展示
     */
    @objc public static func dismiss(delay: TimeInterval = delayTime) {
        WisdomHUD.shared.wisdomLayerView?.hide(delay: delay)
    }
}
