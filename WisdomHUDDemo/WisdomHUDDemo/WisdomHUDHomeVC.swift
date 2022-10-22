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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WisdomCustomNextCell.self)", for: indexPath) as! WisdomCustomNextCell
        let hudStyle = WisdomHUDStyle.allCases[indexPath.section]
        var loadingStyle: WisdomLoadingStyle?
        var textPlaceStyle: WisdomTextPlaceStyle?
        
        switch hudStyle {
        case .succes: break
        case .error: break
        case .warning: break
        case .loading:
            loadingStyle = WisdomLoadingStyle(rawValue: indexPath.row)
        case .text:
            textPlaceStyle = WisdomTextPlaceStyle.allCases[indexPath.row]
        }
        
        cell.setTitle(hudStyle: hudStyle, loadingStyle: loadingStyle, textPlaceStyle: textPlaceStyle)
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
            }.setFocusing()
        case .warning:
            WisdomHUD.showWarning(text: "加载警告", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
                print("")
            }.setFocusing()
        case .loading:
            if let loadingStyle = WisdomLoadingStyle(rawValue: indexPath.row) {
                WisdomHUD.showLoading(text: "正在加载中", loadingStyle: loadingStyle, barStyle: sceneBarStyle, inSupView: view)

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+8) {
                    
                    WisdomHUD.showLoading(text: "覆盖测试中", loadingStyle: loadingStyle, barStyle: .light)

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+8) {
                        WisdomHUD.dismiss()
                    }
                }
            }
        case .text:
            switch WisdomTextPlaceStyle.allCases[indexPath.row] {
            case .center:
                WisdomHUD.showTextCenter(text: "添加失败，请稍后重试", barStyle: sceneBarStyle, inSupView: view, delays: 3) { interval in
                    print("")//加载添加
                }
            case .bottom:
                WisdomHUD.showTextBottom(text: "添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试",
                                         barStyle: sceneBarStyle,
                                         inSupView: view,
                                         delays: 3) { interval in
                    print("")//加载添加
                }.setFocusing()
            default: break
            }
        }
    }
}
