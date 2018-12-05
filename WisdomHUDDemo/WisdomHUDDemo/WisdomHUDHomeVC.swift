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
        
        WisdomHUD.showSuccess(text: "加载成功").delayHanders { (timeInterval, type)  in
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

            WisdomHUD.showLoading(text: "加载中\n三秒后消失")

            //WisdomHUD.showSuccess(text: "2次登录成功")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {

            WisdomHUD.showError(text: "登录失败", delay: TimeInterval(exactly: 3)!)
        }
        
        //WisdomHUD.showSuccess(text: "加载成功", delay: TimeInterval(exactly: 8)!)
        
        //WisdomHUD.showSuccess(text: "加载成功", delay: delayTime, enable: true)
    }
    
    @IBAction func errorButtonClick(_ sender: Any) {
        
        WisdomHUD.showError(text: "加载失败").delayHanders { (timeInterval, type)  in
            
        }
        
        //WisdomHUD.showError(text: "加载失败", delay: TimeInterval(exactly: 8)!)
        
        //WisdomHUD.showError(text: "加载失败", delay: delayTime, enable: false)
    }
    
    @IBAction func infoButtonClick(_ sender: Any) {
        
        WisdomHUD.showInfo(text: "请先注册").delayHanders { (timeInterval, type)  in
            
        }
        
        //WisdomHUD.showInfo(text: "请先注册", delay: TimeInterval(exactly: 8)!)
        
        //WisdomHUD.showInfo(text: "请先注册", delay: delayTime, enable: false)
    }
    
    @IBAction func loadingButtonClick(_ sender: Any) {
        WisdomHUD.shared.loadingStyle = .rotate
        //WisdomHUD.showLoading()
        
        WisdomHUD.showLoading(text: "加载中\n三秒后消失")
        
        //WisdomHUD.showLoading(text: "加载中", enable: true)
        //WisdomHUD.dismiss(delay: TimeInterval(exactly: 3)!)
        //3s关闭
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
           WisdomHUD.showSuccess(text: "登录成功", delay: TimeInterval(exactly: 3)!)
        }
    }
    
    @IBAction func textButtonClick(_ sender: Any) {
        
        WisdomHUD.showText(text: "登录成功").delayHanders { (timeInterval, type) in
            
        }
        
        //WisdomHUD.showText(text: "锄禾日当午", delay: TimeInterval(exactly: 4)!)
        
        //WisdomHUD.showText(text: "权限未开启", delay: delayTime, enable: true)
    }
    
    @IBAction func text2ButtonClick(_ sender: Any) {
        
        let hud = WisdomLayerView(texts: "锄禾日当午汗滴禾下土",
                                  types: .text,
                                  delays: 0,
                                  enable: true,
                                  offset: CGPoint(x: 0, y: view.frame.size.height / 2 - 100))
        hud.backgroundColor = UIColor(red: 18/255, green: 112/255, blue: 238/255, alpha: 0.9)
        hud.show()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            hud.hide(delay: TimeInterval(exactly: 4)!)
        }
    }
}
