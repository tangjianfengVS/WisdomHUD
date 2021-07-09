//
//  WisdomHUDHomeVC.swift
//  WisdomHUDDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomHUDHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func successButtonClick(_ sender: Any) {
//        WisdomHUD.shared.loadingStyle = .system
        
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showSuccess(text: "加载成功").delayHanders { (timeInterval, type)  in
            
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//
//            WisdomHUD.showLoading(text: "")
//
//            //WisdomHUD.showSuccess(text: "2次登录成功")
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
//
//            WisdomHUD.showError(text: "登录失败", delay: TimeInterval(exactly: 3)!)
//        }
        
        //WisdomHUD.showSuccess(text: "加载成功", delay: TimeInterval(exactly: 8)!)
        
        //WisdomHUD.showSuccess(text: "加载成功", delay: delayTime, enable: true)
    }
    
    
    @IBAction func errorButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showError(text: "加载失败").delayHanders { (timeInterval, type)  in

        }

        //WisdomHUD.showError(text: "加载失败", delay: TimeInterval(exactly: 8)!)
        
        //WisdomHUD.showError(text: "加载失败", delay: delayTime, enable: false)
    }
    
    
    @IBAction func infoButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showWarning(text: "请先注册").delayHanders { (timeInterval, type)  in

        }
        
        //WisdomHUD.showInfo(text: "请先注册", delay: TimeInterval(exactly: 8)!)
        
        //WisdomHUD.showInfo(text: "请先注册", delay: delayTime, enable: false)
    }
    
    
    @IBAction func loadingButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.setLoadingStyle(loadingStyle: .rotateBlue)
        
        //WisdomHUD.showLoading()
        
        WisdomHUD.showLoading(text: "加载中，10秒后消失")
        
        //WisdomHUD.showLoading(text: "加载中", enable: true)
        //WisdomHUD.dismiss(delay: TimeInterval(exactly: 3)!)
        //3s关闭
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
           WisdomHUD.showSuccess(text: "Loading 完成", delay: TimeInterval(exactly: 3)!)
        }
    }
    
    
    @IBAction func textButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
//        WisdomHUD.showText(text: "登录成功").delayHanders { (timeInterval, type) in
//
//        }
        
        //WisdomHUD.showText(text: "锄禾日当午", delay: TimeInterval(exactly: 4)!)
        
        WisdomHUD.showText(text: "权限未开启")
    }
    
    
    @IBAction func text2ButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showTextRoot(text: "锄禾日当午汗滴禾下土")
    }
}
