//
//  WisdomHUD+Action.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/8.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

extension WisdomHUD: WisdomHUDActionable {
    
    // MARK: Show Action
    // title/text/label      : UILabel's text
    // leftAction/rightAction: UIBotton's text
    // themeStyle            : UIColor's theme
    // actionClosure         : UIBotton's click closure -> (String, WisdomActionValueStyle) -> (Bool)
    @objc public static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, inSupView: UIView?, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) {
        return WisdomHUDOperate.showAction(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, themeStyle: themeStyle, inSupView: inSupView, actionClosure: actionClosure)
    }
    
    
}
