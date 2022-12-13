//
//  WisdomHUDHomeVC.swift
//  WisdomHUDDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

var sceneBarStyle: WisdomSceneBarStyle = .dark

class WisdomHUDHomeVC: UIViewController {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.wisdom_colorHex(hex: "F4F4F4")
        
        //WisdomHUD.setCoverBackgColor(backgColor: .clear)
        
        edgesForExtendedLayout = UIRectEdge.top
        title = "WisdomHUD"

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.top.bottom.equalTo(view)
        }
        
        tableView.register(WisdomCustomNextCell.self, forCellReuseIdentifier: "\(WisdomCustomNextCell.self)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        let styleView = WisdomBarStyleView(resultClosure: {[weak self] barStyle in
            sceneBarStyle = barStyle
    
            update(barStyle: barStyle)
            
            self?.tableView.reloadData()
        })
        
        let barButtonItem = UIBarButtonItem(customView: styleView)
        navigationItem.rightBarButtonItem = barButtonItem
        
        update(barStyle: sceneBarStyle)
        
        func update(barStyle: WisdomSceneBarStyle){
            switch barStyle {
            case .dark:  view.backgroundColor = UIColor.white
            case .light: view.backgroundColor = UIColor.black
            case .hide:  view.backgroundColor = UIColor.wisdom_colorHex(hex: "F8F8FF")
            }
        }
    }
}

extension WisdomHUDHomeVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return WisdomHUDStyle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let style: WisdomHUDStyle = WisdomHUDStyle.allCases[section]
        switch style {
        case .succes: return 1
        case .error: return 1
        case .warning: return 1
        case .loading: return WisdomLoadingStyle.allCases.count
        case .text: return WisdomTextPlaceStyle.allCases.count
        case .progress: return WisdomProgressStyle.allCases.count
        case .action: return WisdomColorThemeStyle.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WisdomCustomNextCell.self)", for: indexPath) as! WisdomCustomNextCell
        let hudStyle = WisdomHUDStyle.allCases[indexPath.section]
        var loadingStyle: WisdomLoadingStyle?
        var progressStyle: WisdomProgressStyle?
        var textPlaceStyle: WisdomTextPlaceStyle?
        var colorThemeStyle: WisdomColorThemeStyle?
        
        switch hudStyle {
        case .succes: break
        case .error: break
        case .warning: break
        case .loading:
            loadingStyle = WisdomLoadingStyle(rawValue: indexPath.row)
        case .text:
            textPlaceStyle = WisdomTextPlaceStyle.allCases[indexPath.row]
        case .progress:
            progressStyle = WisdomProgressStyle.allCases[indexPath.row]
        case .action:
            colorThemeStyle = WisdomColorThemeStyle.allCases[indexPath.row]
        }
        
        cell.setTitle(hudStyle: hudStyle, loadingStyle: loadingStyle, progressStyle: progressStyle,textPlaceStyle: textPlaceStyle, themeStyle: colorThemeStyle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


extension WisdomHUDHomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let style: WisdomHUDStyle = WisdomHUDStyle.allCases[indexPath.section]
        switch style {
        case .succes:
            WisdomHUD.showSuccess(text: "加载成功", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
                print("")
            }
        case .error:
            WisdomHUD.showError(text: "加载失败", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
                print("")
            }.setFocusing().setTextColor(color: .red).setTextFont(font: UIFont.boldSystemFont(ofSize: 14))
            
        case .warning:
            WisdomHUD.showWarning(text: "加载警告", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
                print("")
            }.setFocusing()
            
        case .loading:
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
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+8) {
//
//                    WisdomHUD.showLoading(text: "覆盖测试中", loadingStyle: loadingStyle, barStyle: .light)
//
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+8) {
//                        WisdomHUD.dismiss()
//                    }
//                }
            }
        case .text:
            switch WisdomTextPlaceStyle.allCases[indexPath.row] {
            case .center:
                WisdomHUD.showTextCenter(text: "inSupView 添加失败，请稍后重试", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
                    print("")//加载添加
                }.setFocusing().setTextColor(color: .blue).setTextFont(font: UIFont.boldSystemFont(ofSize: 14))
                
            case .bottom:
                WisdomHUD.showTextBottom(text: "inSupView 添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试",
                                         barStyle: sceneBarStyle,
                                         inSupView: view,
                                         delays: 3) { interval in
                    print("")//加载添加
                }.setFocusing()
                
            default: break
            }
        case .progress:
            var state: WisdomProgressStyle?
            switch WisdomProgressStyle.allCases[indexPath.row] {
            case .circle: state = .circle
            case .linear: state = .linear
            default: break
            }
            if let cur_state = state {
                let contextable = WisdomHUD.showProgress(text: "上传文件", progressStyle: cur_state, barStyle: sceneBarStyle).setProgreColor(color: .systemPink).setProgreTextColor(color: .systemPink)//.setProgreShadowColor(color: .green)
                let list: [UInt] = [1,2,3,4,5,6,7,8,9,10]
                for item in list {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+TimeInterval(item)) {
                        contextable.setProgreValue(value: item*10)
                        if item*10 >= 100 {
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                                WisdomHUD.dismiss()
                            }
                        }
                    }
                }
            }
        case .action:
            let text1 = "`WisdomHUD` 是一款多种样式的 HUD 弹框指示器 SDK。`WisdomHUD` 系统最低支持 iOS 9.0版本，由Swift 5.0 编写，兼容 OC 类调用使用。"
            let text2 = "`WisdomHUD` 是一款多种样式的 HUD 弹框指示器 SDK。`WisdomHUD` 系统最低支持 iOS 9.0版本，由Swift 5.0 编写，兼容 OC 类调用使用。`WisdomHUD` 支持 全局/单点 HUD 内部属性动态 调整，支持视图 聚焦显示设置。`WisdomHUD` 支持 超时/延迟 时间设置，支持 超时/延迟 结束事件回调处理。`WisdomHUD` 支持多种 Loading/Progress 加载样式，和 succes/error/warning/text 提示样式，支持设置提示动画。`WisdomHUD` 图标通过 绘制实现，且加入了 图标缓存，避让了重复绘制任务，也是 HUD SDK 高性能必经之路。`WisdomHUD` 如果制作成静态库使用，因没有资源文件，不需要考虑资源加载，保证了安全。`WisdomHUD` API 调用方便/灵活，后期会更新迭代，推荐使用。"
            let theme = WisdomColorThemeStyle.allCases[indexPath.row]
            WisdomHUD.showAction(title: "WisdomHUD", text: text2, label: "WisdomHUD sdk", leftAction: "取消", rightAction: "确认", themeStyle: theme, inSupView: nil) { info, value in
                
                return true
            }.setRightAction(textColor: .systemPink, textFont: nil).setLeftAction(textColor: .gray, textFont: nil).setTextAlignment(alignment: .left)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) { [weak self] in
                
                WisdomHUD.showAction(title: "WisdomHUD", text: text1, label: "WisdomHUD sdk", leftAction: nil, rightAction: "确认", themeStyle: theme, inSupView: self?.view) { info, value in
                    
                    return true
                }.setRightAction(textColor: .systemPink, textFont: nil).setLeftAction(textColor: .gray, textFont: nil).setTextAlignment(alignment: .left)
            }
        }
    }
}
