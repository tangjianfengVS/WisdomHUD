# WisdomHUD
https://github.com/tangjianfengVS/WisdomHUD.git

'WisdomHUD' is a variety of styles of HUD pop-up indicator SDK.
'WisdomHUD' system minimum support iOS 9.0 version, written by Swift 5.0, compatible with OC class call use.
'WisdomHUD' supports dynamic adjustment of the internal properties of the global/single-point HUD, and supports the setting of the view focus display.
'WisdomHUD' support timeout/delay time setting, support timeout/delay end event callback processing.
'WisdomHUD' supports multiple Loading load style, and succes/error/warning/text prompt style, allows you to set tip animation.
'WisdomHUD' icon is realized by drawing, and icon cache is added to avoid the repetitive drawing task, which is also the only way for HUD SDK to achieve high performance.
'WisdomHUD' if made into a static library use, because there is no resource file, do not need to consider the resource loading, to ensure security.
'WisdomHUD' API call convenient/flexible, later will update iteration, recommended use.


`WisdomHUD` 是一款多种样式的 HUD 弹框指示器 SDK。 
`WisdomHUD` 系统最低支持 iOS 9.0版本，由Swift 5.0 编写，兼容 OC 类调用使用。 
`WisdomHUD` 支持 全局/单点 HUD 内部属性动态 调整，支持视图 聚焦显示设置。
`WisdomHUD` 支持 超时/延迟 时间设置，支持 超时/延迟 结束事件回调处理。
`WisdomHUD` 支持多种 Loading加载样式，和 succes/error/warning/text 提示样式，支持设置提示动画。
`WisdomHUD` 图标通过 绘制实现，且加入了 图标缓存，避让了重复绘制任务，也是 HUD SDK 高性能必经之路。
`WisdomHUD` 如果制作成静态库使用，因没有资源文件，不需要考虑资源加载，保证了安全。
`WisdomHUD` API 调用方便/灵活，后期会更新迭代，推荐使用。


(1)：`WisdomHUD`的 Loading 加载样式支持：
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

(2)：`WisdomHUD`的 BarStyle 背景样式支持：
/* HUD Scene Bar Style */
@objc public enum WisdomSceneBarStyle: NSInteger, CaseIterable {
    case dark=0    // 黑色
    case light     // 白色
    case hide      // 隐藏
}

(3)：`WisdomHUD`的 TextPlace 位置样式支持：
/* HUD Text Place Style */
@objc public enum WisdomTextPlaceStyle: NSInteger, CaseIterable {
    case center=0  // 中心
    case bottom    // 底部
}

(4)：`WisdomHUD`的 Context Info 信息调整：
/* HUD Text Context Set Info */
@objc public protocol WisdomHUDBaseContextable {
    
    // 文字大小调整
    @discardableResult
    @objc func setTextFont(font: UIFont)->Self
    
    // 文字颜色调整
    @discardableResult
    @objc func setTextColor(color: UIColor)->Self
}

(5)：`WisdomHUD`的 Context Focusing 聚焦设置（去除遮盖视图）：
/* HUD Text Context Set Focusing */
@objc public protocol WisdomHUDContextable: WisdomHUDBaseContextable {
    
    @discardableResult
    @objc func setFocusing()->Self
}

(6)：`WisdomHUD`的 Loading Context Timeout 超时设置：
/* HUD Text Context Set Loading Timeout */
@objc public protocol WisdomHUDLoadingContextable: WisdomHUDBaseContextable {
    
    @discardableResult
    @objc func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self
}
