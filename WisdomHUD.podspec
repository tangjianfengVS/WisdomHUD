Pod::Spec.new do |s|
  s.name         = 'WisdomHUD'
  s.version      = '0.4.3'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { 'tangjianfeng' => '497609288@qq.com' }
  s.homepage     = 'https://github.com/tangjianfengVS/WisdomHUD'
  s.source       = { :git => 'https://github.com/tangjianfengVS/WisdomHUD.git', :tag => s.version }
  s.summary      = 'A simple iOS / macOS interface to display reminders'

  s.description  = 'A simple iOS/macOS interface display prompt, help to develop and implement various data state tracking display and loading tasks. iOS 走完整功能,macOS 提供原生 NSPanel 版本(text/success/error/warning/loading + 位置/主题/自动消失)'

  # 以 Swift 5 语言模式发布:源码使用并发特性(@MainActor/assumeIsolated 等),
  # 但尚未完成 Swift 6 语言模式的完整 actor 隔离改造(全局可变状态/协议一致性跨隔离),
  # Swift 6 模式下会报错。Swift 5 模式下仅为告警,故以 5.0 发布。
  s.swift_version = '5.0'

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.15'

  # 各源文件已用 #if os(iOS)||os(tvOS) / #if os(macOS) 守卫,平台分发由编译器处理。
  # Config.swift 跨平台(纯 enum),HUD_macOS.swift 是 macOS 专属,其余 13 个文件 iOS 专属。
  s.source_files  = "Source/*.swift"

end
