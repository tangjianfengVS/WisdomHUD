//
//  HUD+Action.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/8.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

extension WisdomHUD: WisdomHUDActionable {
    
    // MARK: Show Action
    // title/text            : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, leftAction: String?, rightAction: String, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable{
        return WisdomHUDCore.showAction(title: title, text: text, leftAction: leftAction, rightAction: rightAction, actionClosure: actionClosure)
    }
    
    // MARK: Show Action
    // title/text            : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // themeStyle            : UIColor's theme
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable{
        return WisdomHUDCore.showAction(title: title, text: text, leftAction: leftAction, rightAction: rightAction, themeStyle: themeStyle, actionClosure: actionClosure)
    }
    
    // MARK: Show Action
    // title/text/label      : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // themeStyle            : UIColor's theme
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String,WisdomActionValueStyle)->(Bool))->WisdomHUDActionContextable{
        return WisdomHUDCore.showAction(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, themeStyle: themeStyle, actionClosure: actionClosure)
    }
    
    // MARK: Show Action
    // title/text/label      : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // themeStyle            : UIColor's theme
    // inSupView             : UIView's supView
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @discardableResult
    @objc public static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, inSupView: UIView?, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool))->WisdomHUDActionContextable{
        return WisdomHUDCore.showAction(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, themeStyle: themeStyle, inSupView: inSupView, actionClosure: actionClosure)
    }
}
