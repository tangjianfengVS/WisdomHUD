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

public let delayTime: TimeInterval = 1.5

public let padding: CGFloat = 12

public let cornerRadius: CGFloat = 12.0

public let imageWidth_Height: CGFloat = 36

public let textFont = UIFont.systemFont(ofSize: 14)

public let keyWindow = UIApplication.shared.keyWindow!

public let WisdomHUDIdentifier = "WisdomTypeIdentifier"
