//
//  WisdomHUDHomeVC.swift
//  WisdomHUDDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomHUDHomeVC: UIViewController {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WisdomHUD.showSuccess(text: "欢迎使用 WisdomHUD SDK") { (timeInterval, wisdomHUDType) in
        //    print("")
        //}
        
//        WisdomHUD.showAction(title: "欢迎使用提示",
//                             infoText: "欢迎使用 WisdomHUD SDK。WisdomHUD是一款提示工具，swift编写，兼容OC项目使用，提供了多样化样式！",
//                             tailText: "点击开始体验！",
//                             actionList: ["开始体验"],
//                             themeStyle: WisdomLayerThemeStyle.golden) { actionText, index in
//
//        }
        
        view.backgroundColor = UIColor.wisdom_colorHex(hex: "F4F4F4")
        
        edgesForExtendedLayout = UIRectEdge.top
        title = "WisdomHUD"

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.top.bottom.equalTo(view)
        }
        
        tableView.register(CustomNextCell.self, forCellReuseIdentifier: "\(CustomNextCell.self)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }

//    @IBAction func actionButtonClick(_ sender: Any) {
//
//        WisdomHUD.showAction(title: "锄禾日提示",
//                             infoText: "锄禾日当午汗滴禾下土, 锄禾日当午汗滴禾下土, 锄禾日当午汗滴禾下土, 锄禾日当午汗滴禾下土, 锄禾日当午汗滴禾下土, 锄禾日当午汗滴禾下土, 锄禾日当午汗滴禾下土",
//                             tailText: "一定要节约？",
//                             actionList: ["再想想","我知道了"],
//                             themeStyle: WisdomLayerThemeStyle.red) { actionText, index in
//
//        }
//    }
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
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CustomNextCell.self)", for: indexPath) as! CustomNextCell
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
            WisdomHUD.showSuccess(text: "加载成功", barStyle: .dark, inSupView: view, delays: 5) { interval in
                print("")
            }
        case .error:
            WisdomHUD.showError(text: "加载失败", barStyle: .dark, delays: 5) { interval in
                print("")
            }
        case .warning:
            WisdomHUD.showWarning(text: "加载警告", barStyle: .dark, delays: 5) { interval in
                print("")
            }
        case .loading:
            if let loadingStyle = WisdomLoadingStyle(rawValue: indexPath.row) {
                WisdomHUD.showLoading(text: "正在加载中", loadingStyle: loadingStyle, barStyle: .dark, inSupView: view)

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+15) {
                    WisdomHUD.dismiss()
                }
            }
        case .text:
            switch WisdomTextPlaceStyle.allCases[indexPath.row] {
            case .center:
                WisdomHUD.showTextCenter(text: "添加失败，请稍后重试", barStyle: .dark, inSupView: view, delays: 3) { interval in
                    print("")//加载添加
                }
            case .bottom:
                WisdomHUD.showTextBottom(text: "添加失败，请稍后重试", barStyle: .dark, inSupView: view, delays: 3) { interval in
                    print("")//加载添加
                }
            default: break
            }
        }
    }
}
