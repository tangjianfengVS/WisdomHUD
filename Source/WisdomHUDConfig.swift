//
//  WisdomHUDConfig.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

/* HUD Style */
enum WisdomHUDStyle: CaseIterable {
    case succes   // image + text
    case error    // image + text
    case warning  // image + text
    case loading  // image + text
    case text     // text
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


///* HUD Action主题类型 */
//@objc public enum WisdomLayerThemeStyle: NSInteger {
//    case yigou=0       // 透明黑
//    case snowWhite     // 雪白
//    case blue          // 品蓝
//    case dodgerBlue    // 宝蓝
//    case golden        // 亮金
//    case red           // 品红
//}
