//
//  WisdomHUDConfig.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

/* HUD展示类型 */
@objc public enum WisdomHUDType: NSInteger {
    case success=0  // image + text
    case error      // image + text
    case warning    // image + text
    case loading    // image
    case textCentre // text
    case textRoot   // text
}


/* HUD遮罩颜色类型 */
@objc public enum WisdomCoverBarStyle: NSInteger {
    case dark=0    // 黑色半透明
    //case light     // 白色半透明
    case skyBlue   // 天蓝半透明
    case hide      // 隐藏
}


/* HUD Loading类型 */
@objc public enum WisdomLoadingStyle: NSInteger {
    case system=0   // 系统的菊花
    case rotate     // 经典的旋圈
    case rotateBlue // 夜空蓝
}


/* HUD Action主题类型 */
@objc public enum WisdomLayerThemeStyle: NSInteger {
    case yigou=0       // 透明黑
    case snowWhite     // 雪白
    case blue          // 品蓝
    case dodgerBlue    // 宝蓝
    case golden        // 亮金
    case red           // 品红
}



let HUD_ImageWidth_Height: CGFloat = 28

let WisdomHUDWindowTag: NSInteger = 901018


// MARK: Height or Width -> iPhone 6, iPhone 7, iPhone 8 及以下为小屏
public let IsSmallScreen: Bool = WisdomLayerCoverView.isSmallScreen()
