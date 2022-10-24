# WisdomHUD
`WisdomHUD` 是一款多种样式的 HUD 弹框指示器 SDK。 
`WisdomHUD` 系统最低支持 iOS 9.0版本，由Swift 5.0 编写，兼容 OC 类调用使用。 
`WisdomHUD` 支持全局/单点 HUD 属性动态调整，支持延迟时间设置，支持延迟结束事件回调处理。
`WisdomHUD` 支持多种 Loading加载，和succes/error/warning/text 提示样式，支持设置提示动画，API 调用方便/灵活。
`WisdomHUD` 图标通过绘制实现，且加入了图标缓存，避让了重复绘制任务，也是 HUD SDK 必经之路。

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
