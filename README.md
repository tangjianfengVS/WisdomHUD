# WisdomHUD
https://github.com/tangjianfengVS/WisdomHUD.git

  'WisdomHUD' is a variety of styles of HUD pop-up indicator SDK.

  'WisdomHUD' system minimum support iOS 9.0 version, written by Swift 5.0, compatible with OC class call use.

  'WisdomHUD' supports dynamic adjustment of the internal properties of the global/single-point HUD, and supports the setting of the view focus display.

  'WisdomHUD' support timeout/delay time setting, support timeout/delay end event callback processing.

  'WisdomHUD' supports multiple Loading/Progress load style, and succes/error/warning/text prompt style, allows you to set tip animation.

  'WisdomHUD' icon is realized by drawing, and icon cache is added to avoid the repetitive drawing task, which is also the only way for HUD SDK to achieve high performance.

  'WisdomHUD' if made into a static library use, because there is no resource file, do not need to consider the resource loading, to ensure security.

  'WisdomHUD' API call convenient/flexible, later will update iteration, recommended use.

  `WisdomHUD` Support control multiple attributes (text size/text color/text content) dynamic update.

  `WisdomHUD` Support animation control view customization.


# WisdomHUD
  `WisdomHUD` 是一款多种样式的 HUD 弹框指示器 SDK。

  `WisdomHUD` 系统最低支持 iOS 9.0版本，由Swift 5.0 编写，兼容 OC 类调用使用。

  `WisdomHUD` 支持 全局/单点 HUD 内部属性动态 调整，支持视图 聚焦显示设置。

  `WisdomHUD` 支持 超时/延迟 时间设置，支持 超时/延迟 结束事件回调处理。

  `WisdomHUD` 支持多种 Loading/Progress/Action 加载样式，和 succes/error/warning/text 提示样式，支持设置提示动画。
  
  `WisdomHUD` 图标通过 绘制实现，且加入了 图标缓存，避让了重复绘制任务，也是 HUD SDK 高性能必经之路。

  `WisdomHUD` 如果制作成静态库使用，因没有资源文件，不需要考虑资源加载，保证了安全。

  `WisdomHUD` API 调用方便/灵活，后期会更新迭代，推荐使用。

  `WisdomHUD` 支持控件多属性（文字大小/文字颜色/文字内容）动态更新。

  `WisdomHUD` 支持动画控件视图自定义。


# WisdomHUD
   ![image](https://github.com/tangjianfengVS/WisdomHUD/blob/master/IMG/IMG_HUD.png)


# WisdomHUD
(1)：`WisdomHUD`的 所有样式支持：

    /* HUD Style */
    public enum WisdomHUDStyle: CaseIterable {

      case succes   // image + text
    
      case error    // image + text
    
      case warning  // image + text
    
      case loading  // image + text
        
      case progress // image + text
    
      case text     // text
    }

(2)：`WisdomHUD`的 Loading 加载样式支持：

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

(3)：`WisdomHUD`的 Progress 加载样式支持：

    /* HUD Progress Style */
    @objc public enum WisdomProgressStyle: NSInteger, CaseIterable {

      case circle=0  // 中心圆
      
      case linear    // 线型
      
      case water     // 水球
    }

(4)：`WisdomHUD`的 BarStyle 背景样式支持：

    /* HUD Scene Bar Style */
    @objc public enum WisdomSceneBarStyle: NSInteger, CaseIterable {

      case dark=0    // 黑色
    
      case light     // 白色
    
      case hide      // 隐藏
    }

(5)：`WisdomHUD`的 TextPlace 位置样式支持：

    /* HUD Text Place Style */
    @objc public enum WisdomTextPlaceStyle: NSInteger, CaseIterable {

      case center=0  // 中心
    
      case bottom    // 底部
    }

(6)：`WisdomHUD`的 Context Info 信息调整：

    /* HUD Text Context Set Info */
    @objc public protocol WisdomHUDBaseContextable {
    
      // 文字大小调整
      @discardableResult
      @objc func setTextFont(font: UIFont)->Self
    
      // 文字颜色调整
      @discardableResult
      @objc func setTextColor(color: UIColor)->Self
    
      // 文字内容更新
      @discardableResult
      @objc func setUpdateText(text: String)->Self
    
      // 动画视图自定义
      @discardableResult
      @objc func setAnimation(view: UIView)->Self
    }

(7)：`WisdomHUD`的 Context Focusing 聚焦设置（去除遮盖视图，允许底部试图交互，Loading HUD不支持）：

    /* HUD Text Context Set Focusing */
    @objc public protocol WisdomHUDContextable: WisdomHUDBaseContextable {
    
      @discardableResult
      @objc func setFocusing()->Self
    }

(8)：`WisdomHUD`的 Loading Context Timeout 超时设置（超时时间到了 Loading HUD 回调结束，并自动移除）：

    /* HUD Text Context Set Loading Timeout */
    @objc public protocol WisdomHUDLoadingContextable: WisdomHUDBaseContextable {
    
      @discardableResult
      @objc func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self
    }

(9)：`WisdomHUD`的 全局属性设置：

    /* HUD Setting able */
    extension WisdomHUD: WisdomHUDSettingable {
    
      // MARK: HUD Set Loading Style 加载样式
      @objc public static func setLoadingStyle(loadingStyle: WisdomLoadingStyle)
    
      // MARK: HUD Set Scene Bar Style bar颜色
      @objc public static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle)
    
      // MARK: HUD Set Display Delay 显示时长
      @objc public static func setDisplayDelay(delayTime: CGFloat)
    
      // MARK: HUD Set Cover BackgColor 背景颜色
      @objc public static func setCoverBackgColor(backgColor: UIColor)
    }

(10)：`WisdomHUD`的 使用案例：

    let style: WisdomHUDStyle = WisdomHUDStyle.allCases[indexPath.section]
    
    switch style {
    
    case .succes:  // 成功样式：延迟时间设置
    
        WisdomHUD.showSuccess(text: "加载成功", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
        
            print("3秒显示结束")
                
        }
            
    case .error:  // 失败样式：延迟时间设置/指定视图添加/设置聚焦/设置文字颜色和大小
    
        WisdomHUD.showError(text: "加载失败", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
                
            print("3秒显示结束")
                
        }.setFocusing().setTextColor(color: .red).setTextFont(font: UIFont.boldSystemFont(ofSize: 14))
            
    case .warning: // 警告样式：延迟时间设置/指定视图添加/设置聚焦
    
        WisdomHUD.showWarning(text: "加载警告", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
        
            print("3秒显示结束")
            
        }.setFocusing()
            
    case .loading: // 加载样式：异步加载/超时时间设置
    
        if let loadingStyle = WisdomLoadingStyle(rawValue: indexPath.row) {
        
            DispatchQueue.global().async {
                    
                WisdomHUD.showLoading(text: "正在加载中",
                
                                      loadingStyle: loadingStyle,
                                      
                                      barStyle: sceneBarStyle).setTimeout(time: 8) { _ in
                        
                    WisdomHUD.showTextBottom(text: "加载超时，稍后重试",
                    
                                                 barStyle: sceneBarStyle,
                                                 
                                                 delays: 5, delayClosure: nil).setFocusing()
                        
                }
                    
            }
    
        }
        
    case .text: // 文字样式
    
        switch WisdomTextPlaceStyle.allCases[indexPath.row] {
        
        case .center: // 中心文字样式：延迟时间设置/指定视图添加/设置聚焦/设置文字颜色和大小
        
            WisdomHUD.showTextCenter(text: "inSupView 添加失败，请稍后重试", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
            
                print("3秒显示结束")
                
            }.setFocusing().setTextColor(color: .blue).setTextFont(font: UIFont.boldSystemFont(ofSize: 14))
                
        case .bottom: // 底部文字样式：延迟时间设置/指定视图添加/设置聚焦
        
            WisdomHUD.showTextBottom(text: "inSupView 添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试",
            
                                     barStyle: sceneBarStyle,
                                         
                                     inSupView: view,
                                     
                                     delays: 3) { interval in
                                     
                print("3秒显示结束")
                
            }.setFocusing()
                
        default: break
        
        }
        
    case .progress: // 进度样式：设置进度颜色/设置进度文字颜色/设置进度值/完成移除
    
        let contextable = WisdomHUD.showProgress(text: "上传文件").setProgressColor(color: .systemPink).setProgressTextColor(color: .systemPink)
        
        let list: [UInt] = [1,2,3,4,5,6,7,8,9,10]
        
        for item in list {
        
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+TimeInterval(item)) {
            
                contextable.setProgressValue(value: item*10)
                
                if item*10 >= 100 {
                        
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
                    
                        WisdomHUD.dismiss()
                        
                    }
                    
                }
                
            }
            
        }
        
    }
