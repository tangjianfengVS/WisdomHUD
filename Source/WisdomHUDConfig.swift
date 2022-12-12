//
//  WisdomHUDConfig.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

/* HUD Style */
public enum WisdomHUDStyle: CaseIterable {
    case succes   // image + text
    case error    // image + text
    case warning  // image + text
    case loading  // image + text
    case progress // image + text
    case text     // text
    case action   // title/text/click
}


/* HUD Loading Style */
@objc public enum WisdomLoadingStyle: NSInteger, CaseIterable {
    case system=0     // 系统菊花
    case rotate       // 经典旋圈
    case progressArc  // 缩进弧
    case tadpoleArc   // 蝌蚪弧
    case chaseBall    // 追逐球
    case pulseBall    // 脉冲球
    case pulseShape   // 脉冲形状
}


/* HUD Scene Bar Style */
@objc public enum WisdomSceneBarStyle: NSInteger, CaseIterable {
    case dark=0    // 黑色
    case light     // 白色
    case hide      // 隐藏
}


/* HUD Text Place Style */
@objc public enum WisdomTextPlaceStyle: NSInteger, CaseIterable {
    case center=0  // 中心
    case bottom    // 底部
}


/* HUD Progress Style */
@objc public enum WisdomProgressStyle: NSInteger, CaseIterable {
    case circle=0  // 中心圆
    case linear    // 线型
}


/* HUD Theme Color Style */
@objc public enum WisdomColorThemeStyle: NSInteger, CaseIterable{
    case light=0    // 雪白色
    case dark       // 透明暗
    case dodgerBlue // 成功-宝蓝
    case blue       // 成功/品蓝
    case red        // 错误/品红
    case golden     // 警告/亮金
}

/* HUD Action Value Style */
@objc public enum WisdomActionValueStyle: NSInteger, CaseIterable{
    case left=0
    case right
}
