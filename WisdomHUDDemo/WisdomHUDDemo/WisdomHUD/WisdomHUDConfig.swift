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


/* HUD  Loading类型 */
@objc public enum WisdomLoadingStyle: NSInteger {
    case system=0   // 系统的菊花
    case rotate     // 经典的旋圈
    case rotateBlue // 夜空蓝
}


let HUD_CornerRadius: CGFloat = 10.0

let HUD_ImageWidth_Height: CGFloat = 28

let HUD_MIN_Width: CGFloat = 110

let HUD_MAX_Width: CGFloat = 200

let HUD_Text_Padding_LRT: CGFloat = 12.0

let HUD_Text_Padding_Middle: CGFloat = 5.0

let HUD_Text_Padding_Bottom: CGFloat = 10.0

let HUD_Text_Font: CGFloat = 13.0

let WisdomHUDWindowTag: NSInteger = 901018
