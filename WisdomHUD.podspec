Pod::Spec.new do |s|
  s.name         = 'WisdomHUD'
  s.version      = '0.4.3'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { 'tangjianfeng' => '497609288@qq.com' }
  s.homepage     = 'https://github.com/tangjianfengVS/WisdomHUD'
  s.source       = { :git => 'https://github.com/tangjianfengVS/WisdomHUD.git', :tag => s.version }
  s.summary      = 'A simple iOS / macOS interface to display reminders'

  s.description  = 'A simple iOS/macOS interface display prompt, help to develop and implement various data state tracking display and loading tasks. iOS 走完整功能,macOS 提供原生 NSPanel 版本(text/success/error/warning/loading + 位置/主题/自动消失)'

  s.swift_version= ['5.5', '5.6', '5.7', '5.8', '5.9', '6.0']

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.15'

  # 各源文件已用 #if os(iOS)||os(tvOS) / #if os(macOS) 守卫,平台分发由编译器处理。
  # Config.swift 跨平台(纯 enum),HUD_macOS.swift 是 macOS 专属,其余 13 个文件 iOS 专属。
  s.source_files  = "Source/*.swift"

end
