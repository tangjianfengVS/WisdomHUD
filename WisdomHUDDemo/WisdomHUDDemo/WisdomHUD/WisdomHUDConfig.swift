//
//  WisdomHUDConfig.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

/** HUD展示类型 */
@objc public enum WisdomHUDType: NSInteger {
    case success=0 // image + text
    case error=1   // image + text
    case info=2    // image + text
    case loading=3 // image
    case text=4    // text
}

/** HUD遮罩颜色类型 */
@objc public enum WisdomCoverBarStyle: NSInteger {
  
    case dark=0    // 黑色半透明
    case light=1   // 白色半透明
    case skyBlue=2 // 天蓝半透明
}

/** HUD指示Loading类型 */
@objc public enum WisdomLoadingStyle: NSInteger {
    case system=0   // 系统的菊花
    case rotate=1   // 经典的旋圈
}

public let HUD_DelayTime: TimeInterval = 1.5

public let HUD_CornerRadius: CGFloat = 12.0

public let HUD_ImageWidth_Height: CGFloat = 34

public let HUD_MIN_Width: CGFloat = 110

public let HUD_MAX_Width: CGFloat = 180

public let HUD_Text_Padding_LR: CGFloat = 12.0

public let HUD_Text_Padding_TB: CGFloat = 12.0

public let HUD_Text_Font = UIFont.systemFont(ofSize: 14)

public let WisdomHUDIdentifier = "WisdomTypeIdentifier"
