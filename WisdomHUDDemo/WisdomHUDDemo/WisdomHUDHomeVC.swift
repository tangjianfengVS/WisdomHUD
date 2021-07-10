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
        
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showSuccess(text: "加载成功").setDelayHander { (timeInterval, type)  in
            
        }
        
    }
    
    
    @IBAction func errorButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showError(text: "加载失败").setDelayHander { (timeInterval, type)  in

        }
    }
    
    
    @IBAction func infoButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showWarning(text: "请先注册").setDelayHander { (timeInterval, type)  in

            print("")
        }

    }
    
    
    @IBAction func loadingButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.setLoadingStyle(loadingStyle: .system)
        
        WisdomHUD.showLoading(text: "加载中，8秒后消失")
        
        //8s关闭
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
           WisdomHUD.showSuccess(text: "Loading 完成", delay: TimeInterval(exactly: 3)!)
        }
    }
    
    
    @IBAction func textButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showText(text: "权限未开启")
    }
    
    
    @IBAction func text2ButtonClick(_ sender: Any) {
        WisdomHUD.setCoverBarStyle(coverBarStyle: .dark)
        
        WisdomHUD.showTextRoot(text: "锄禾日当午汗滴禾下土")
    }
}
