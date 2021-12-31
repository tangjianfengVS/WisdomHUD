Pod::Spec.new do |s|
  s.name         = "WisdomHUD"
  s.version      = "0.1.9"
  s.summary      = "A simple iOS interface to display reminders"
  s.description  = "A simple iOS interface display prompt, help to develop and implement various data state tracking display and loading tasks"

  s.homepage     = "https://github.com/tangjianfengVS/WisdomHUD"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "tangjianfeng" => "497609288@qq.com" }
  s.platform     = :ios, "9.0"
  s.swift_version= '4.2'
  s.ios.deployment_target = "9.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/tangjianfengVS/WisdomHUD.git", :tag => s.version }

  s.source_files  = "Source/*.swift"
  s.resources = "Source/WisdomHUD.bundle"
end
