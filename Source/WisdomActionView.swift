//
//  WisdomActionView.swift
//  WisdomHUDDemo
//
//  Created by tangjianfeng on 2021/12/23.
//  Copyright © 2021 All over the sky star. All rights reserved.
//

import UIKit


struct WisdomActionThemeModel {
    
    let themeStyle: WisdomActionThemeStyle
    
    let titleColor: UIColor   // 标题
    let infoClor: UIColor     // 详情
    let tailClor: UIColor     // 尾签

    let rightBtnClor: UIColor  // 确认
    let topBarColor: UIColor   // Bar
    let layerColor: UIColor    // 阴影
    
    init(themeStyle: WisdomActionThemeStyle){
        self.themeStyle = themeStyle
        
        switch themeStyle{
        case .snowWhite:
            titleColor = UIColor.white
            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
            layerColor = topBarColor
            rightBtnClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
 
            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.8)
            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
        case .blue:
            titleColor = UIColor.white
            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "4169E1")
            layerColor = topBarColor
            rightBtnClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
            
            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.8)
            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
        case .golden:
            titleColor = UIColor.wisdom_SCHEXCOLOR(hex: "CD853F")
            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "D9D919")
            layerColor = topBarColor
            rightBtnClor = UIColor.wisdom_SCHEXCOLOR(hex: "CD853F")
            
            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.8)
            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
        case .red:
            titleColor = UIColor.white
            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "E3170D")
            layerColor = topBarColor
            rightBtnClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
            
            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.8)
            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
        }
    }
}



class WisdomActionView: UIView {
    
    private let titleLab = UILabel()

    private let infoLab = UILabel()
    
    private let middleVI = UIView()
    
    private let tailLab = UILabel()

    private let acrossLineVI = UIView()

    private let betweenLineVI = UIView()

    private let leftBtn = UIButton()

    private let rightBtn = UIButton()
    
    private let hitView = UIView()
    
    private let themeModel: WisdomActionThemeModel

    private let actionHandler: (String, NSInteger)->()
    
    
    init(title: String,
         infoText: String,
         tailText: String,
         actionList: [String],
         themeStyle: WisdomActionThemeStyle,
         actionHandler: @escaping (String, NSInteger)->()) {
    
        self.themeModel = WisdomActionThemeModel(themeStyle: themeStyle)
        self.actionHandler = actionHandler
        super.init(frame: .zero)
        
        backgroundColor = UIColor.white

        translatesAutoresizingMaskIntoConstraints = false
        
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        
        infoLab.translatesAutoresizingMaskIntoConstraints = false
        
        tailLab.translatesAutoresizingMaskIntoConstraints = false
        
        acrossLineVI.translatesAutoresizingMaskIntoConstraints = false
        
        betweenLineVI.translatesAutoresizingMaskIntoConstraints = false
        
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
    
        middleVI.translatesAutoresizingMaskIntoConstraints = false
        
        hitView.translatesAutoresizingMaskIntoConstraints = false
        
        let width: CGFloat = IsSmallScreen ? 260 : 270
        
        let height: CGFloat = width*0.75
        
        let colorVI = WisdomLayerCoverView.createColorLayerView(width: width, height:32, color: themeModel.topBarColor)

        addSubview(colorVI)

        addSubview(titleLab)

        addSubview(infoLab)
        
        addSubview(tailLab)

        addSubview(acrossLineVI)
        
        addSubview(betweenLineVI)
        
        addSubview(leftBtn)
        
        addSubview(rightBtn)
        
        addSubview(middleVI)
        
        addSubview(hitView)
    
        addConstraint(with: titleLab,
                      topView: colorVI,
                      leftView: self,
                      bottomView: colorVI,
                      rightView: self,
                      edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        // info
        addConstraint(with: infoLab,
                      topView: colorVI,
                      leftView: self,
                      bottomView: nil,
                      rightView: self,
                      edgeInset: UIEdgeInsets(top: 50, left: 20, bottom: -22, right: -20))
        
        
        acrossLineVI.addConstraint(width: 0, height: 1)
        
        addConstraint(with: middleVI,
                      topView: nil,
                      leftView: infoLab,
                      bottomView: infoLab,
                      rightView: infoLab,
                      edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        // tail
        addConstraint(with: tailLab,
                      topView: middleVI,
                      leftView: hitView,
                      bottomView: nil,
                      rightView: middleVI,
                      edgeInset: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0))

        // acrossLine
        acrossLineVI.addConstraint(width: 0, height: 0.5)

        addConstraint(with: acrossLineVI,
                      topView: nil,
                      leftView: self,
                      bottomView: self,
                      rightView: self,
                      edgeInset: UIEdgeInsets(top: 20, left: 0, bottom: -40, right: 0))
        
        // betweenLine
        betweenLineVI.addConstraint(width: 0.5, height: 0)
        
        addConstraint(toCenterX: betweenLineVI, toCenterY: nil)
        
        addConstraint(with: betweenLineVI,
                      topView: acrossLineVI,
                      leftView: nil,
                      bottomView: self,
                      rightView: nil,
                      edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        // hit
        hitView.addConstraint(width: 7, height: 7)
        
        addConstraint(with: hitView,
                      topView: tailLab,
                      leftView: self,
                      bottomView: nil,
                      rightView: nil,
                      edgeInset: UIEdgeInsets(top: 4, left: 20, bottom: 0, right: 0))
        
        addConstraint(width: width, height: height)
        
        middleVI.backgroundColor = UIColor.clear
        
        titleLab.text = title
        
        titleLab.textColor = themeModel.titleColor
        
        titleLab.textAlignment = .center
        
        titleLab.font = UIFont.boldSystemFont(ofSize: 15)
        
        titleLab.sizeToFit()
        
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 3 //行间距设置

        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.paragraphStyle: paraph]
        infoLab.attributedText = NSAttributedString(string: infoText, attributes: attributes)
        
        infoLab.textAlignment = .left
        
        infoLab.backgroundColor = UIColor.clear
        
        infoLab.numberOfLines = 4
        
        infoLab.lineBreakMode = .byTruncatingTail

        infoLab.textColor = themeModel.infoClor
        
        infoLab.sizeToFit()
        
        
        tailLab.text = tailText
        
        tailLab.font = UIFont.systemFont(ofSize: 14)
        
        tailLab.numberOfLines = 2

        tailLab.textColor = themeModel.tailClor
        
        tailLab.sizeToFit()
        
        acrossLineVI.backgroundColor = UIColor(white: 0.85, alpha: 1)
        
        betweenLineVI.backgroundColor = acrossLineVI.backgroundColor
        
        
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        leftBtn.setTitleColor(UIColor.wisdom_SCHEXCOLOR(hex: "34495E", alpha: 0.8), for: .normal)
        
        leftBtn.addTarget(self, action: #selector(clickActionBtn), for: .touchUpInside)
        
        rightBtn.titleLabel?.font = leftBtn.titleLabel?.font
        
        rightBtn.setTitleColor(themeModel.rightBtnClor, for: .normal)
        
        rightBtn.addTarget(self, action: #selector(clickActionBtn), for: .touchUpInside)
        
        hitView.backgroundColor = themeModel.rightBtnClor
        
        hitView.layer.masksToBounds = true
        
        hitView.layer.cornerRadius = 7/2
        
        setactionList(actionList: actionList)
    }
    
    
    private func setactionList(actionList: [String]){

        if actionList.count >= 2 {
            betweenLineVI.isHidden = false
            
            leftBtn.setTitle(actionList.first!, for: .normal)
            leftBtn.setTitle(actionList.first!, for: .highlighted)
            leftBtn.tag = 0
            leftBtn.isHidden = false
            
            rightBtn.setTitle(actionList[1], for: .normal)
            rightBtn.setTitle(actionList.first!, for: .highlighted)
            rightBtn.tag = 1
            rightBtn.isHidden = false
            
            addConstraint(with: leftBtn,
                          topView: acrossLineVI,
                          leftView: self,
                          bottomView: self,
                          rightView: betweenLineVI,
                          edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            
            addConstraint(with: rightBtn,
                          topView: acrossLineVI,
                          leftView: betweenLineVI,
                          bottomView: self,
                          rightView: self,
                          edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            
        }else if actionList.count == 1{
            betweenLineVI.isHidden = true
            
            leftBtn.isHidden = true
            leftBtn.setTitle("", for: .highlighted)
            
            rightBtn.isHidden = false
            rightBtn.setTitle(actionList.first, for: .normal)
            rightBtn.setTitle(actionList.first!, for: .highlighted)
            rightBtn.tag = 0
            
            addConstraint(with: rightBtn,
                          topView: acrossLineVI,
                          leftView: self,
                          bottomView: self,
                          rightView: self,
                          edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }else {
            betweenLineVI.isHidden = true
            
            leftBtn.isHidden = true
            leftBtn.setTitle("", for: .highlighted)
            
            rightBtn.isHidden = true
            rightBtn.setTitle("", for: .highlighted)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc private func clickActionBtn(_ sender: UIButton) {
        WisdomHUD.dismiss()
        
        let text: String = (sender.titleLabel == nil) ? "" : sender.titleLabel!.text!
        
        actionHandler(text, sender.tag)
    }
    

    fileprivate func setShadow() {
        backgroundColor = UIColor.white

        layer.cornerRadius = 5

        layer.shadowOffset = CGSize.init(width: 0, height: 0)

        layer.shadowOpacity = 0.5

        layer.shadowRadius = 6
        
        layer.shadowColor = themeModel.layerColor.cgColor
    }

}



extension WisdomActionView: WisdomHUDProtocol {
    
    /* Action HUD */
    static func showAction(title: String,
                           infoText: String,
                           tailText: String,
                           actionList: [String],
                           themeStyle: WisdomActionThemeStyle,
                           actionHandler: @escaping (String, NSInteger)->()) {
        DispatchQueue.main.async {
            let actionView = WisdomActionView(title: title,
                                              infoText: infoText,
                                              tailText: tailText,
                                              actionList: actionList,
                                              themeStyle: themeStyle,
                                              actionHandler: actionHandler)

            actionView.addToWindow()

            actionView.setShadow()
            
            actionView.keepTime()
        }
    }
    
    
    /* Action HUD */
//    static func showAction(text: String?,
//                           textColor: UIColor?,
//                           delay: TimeInterval,
//                           barStyle: WisdomCoverBarStyle,
//                           delayHandler: ((TimeInterval, WisdomHUDType)->())?) {
//        DispatchQueue.main.async {
//            let layerView = WisdomLayerView(texts: text,
//                                            textColor: textColor,
//                                            types: .success,
//                                            barStyle: barStyle,
//                                            delays: delay,
//                                            delayHandler: delayHandler)
//
//            layerView.addToWindow()
//
//            layerView.keepTime()
//        }
//    }
    
    
    /* 展示 */
    func addToWindow() {
        let window = WisdomHUD.getScreenWindow()
        
        if window != nil {
            let currentView = window!.viewWithTag(WisdomHUDWindowTag)
            //let offsetY = window!.bounds.size.height/10.0
            
            if let hudCoverVI = currentView as? WisdomLayerCoverView {
                for view in hudCoverVI.subviews {
                    view.removeFromSuperview()
                }
                
                hudCoverVI.addSubview(self)
                
                hudCoverVI.addConstraint(toCenterX: self, toCenterY: self)
            }else {
                let coverVI = WisdomLayerCoverView()
                
                coverVI.translatesAutoresizingMaskIntoConstraints = false
                
                coverVI.backgroundColor = UIColor(white: 0, alpha: 0.35)
                
                coverVI.tag = WisdomHUDWindowTag
               
                window!.addSubview(coverVI)
                
                window!.addConstraint(with: coverVI,
                                   topView: window!,
                                  leftView: window!,
                                bottomView: window!,
                                 rightView: window!,
                                 edgeInset: UIEdgeInsets.zero)
                
                coverVI.addSubview(self)
                
                coverVI.addConstraint(toCenterX: self, toCenterY: self)
            }
        }
    }
    
    
    func keepTime() {
        
    }
    
    
    func animateEnd() {
        
    }
    
}


//public class CTRemarkTool {
//
//    public class func showRemark(title: String,
//                                 text: String,
//                                 btnInfos: [String],
//                                 closure: @escaping (NSInteger)->()) {
//        let window = UIApplication.shared.keyWindow
//        let currentView = window?.viewWithTag(CTRemarkTool_Tag)
//        if currentView != nil {
//
//        }else {
//            let aView = CTRemarkVI()
//            window?.addSubview(aView)
//            aView.tag = CTRemarkTool_Tag
//
//            aView.snp.makeConstraints { (make) in
//                make.edges.equalTo(window!)
//            }
//
//            aView.titleLab.text = title
//            aView.mClosure = closure
//
//            let paraph = NSMutableParagraphStyle()
//            paraph.lineSpacing = 6 //行间距设置
//
//            let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13),
//                              NSAttributedString.Key.paragraphStyle: paraph]
//            aView.infoLab.attributedText = NSAttributedString(string: text, attributes: attributes)
//
//            if btnInfos.count == 0 {
//                aView.rightBtn.isHidden = true
//                aView.leftBtn.isHidden = true
//            }else if btnInfos.count == 1 {
//                aView.leftBtn.isHidden = true
//                aView.betweenLineVI.isHidden = true
//
//                aView.rightBtn.setTitle(btnInfos.first!, for: .normal)
//                aView.rightBtn.tag = 0
//
//                aView.rightBtn.snp.remakeConstraints { (make) in
//                    make.left.right.bottom.equalTo(aView.coverView)
//                    make.height.equalTo(aView.leftBtn)
//                }
//            }else if btnInfos.count >= 2 {
//                aView.leftBtn.setTitle(btnInfos.first!, for: .normal)
//                aView.rightBtn.setTitle(btnInfos[1], for: .normal)
//                aView.leftBtn.tag = 0
//                aView.rightBtn.tag = 1
//            }
//
//            aView.setShadow()
//        }
//    }
//
//
//    public class func showSelPicture(actionInfos: [String],
//                                     selClosure: @escaping (NSInteger)->(),
//                                     cancelClosure: @escaping ()->()) {
//        let window = UIApplication.shared.keyWindow
//        let currentView = window?.viewWithTag(CTRemarkTool_Tag)
//        if currentView != nil {
//
//        }else {
//            let aView = CTSelPictureHUD()
//            window?.addSubview(aView)
//            aView.tag = CTRemarkTool_Tag
//
//            aView.mClosure = selClosure
//            aView.cancelClosure = cancelClosure
//
//            for info in actionInfos {
//                aView.mActionInfos.insert(info, at: 0)
//            }
//
//            aView.snp.makeConstraints { (make) in
//                make.edges.equalTo(window!)
//            }
//
//            aView.setItemInfo()
//        }
//    }
//
//
//    public class func dismiss() {
//        let window = UIApplication.shared.keyWindow
//        let currentView = window?.viewWithTag(CTRemarkTool_Tag)
//
//        if currentView != nil {
//            currentView?.removeFromSuperview()
//        }
//    }
//}
//
//
//class CTRemarkVI: UIView {
//
//    let coverView = UIView()

    //let bgVI = UIImageView(image: UIImage(named: "CT_All_Logo"))

//    let titleLab = UILabel()
//
//    let infoLab = UILabel()
//
//    let acrossLineVI = UIView()
//
//    let betweenLineVI = UIView()
//
//    let leftBtn = UIButton()
//
//    let rightBtn = UIButton()
//
//
//    var mClosure: ((NSInteger)->())?
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor(white: 0, alpha: 0.5)
//
//        let coverWidth: CGFloat = 250
//
//        addSubview(coverView)
//
//        let colorVI = CTRemarkVI.setColorLayers(width: coverWidth)
//
//        coverView.addSubview(colorVI)
//
//        //coverView.addSubview(bgVI)
//
//        coverView.addSubview(titleLab)
//
//        coverView.addSubview(infoLab)
//
//        coverView.addSubview(acrossLineVI)
//
//        coverView.addSubview(betweenLineVI)
//
//        coverView.addSubview(leftBtn)
//
//        coverView.addSubview(rightBtn)
//
//        coverView.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//            make.centerY.equalTo(self).offset(-20)
//            make.width.equalTo(coverWidth)
//            make.height.equalTo(180)
//        }
//
//        //bgVI.alpha = 0.1
//        //bgVI.contentMode = .scaleAspectFit
//        //bgVI.snp.makeConstraints { (make) in
//        //    make.edges.equalTo(coverView)
//        //}
//
//        titleLab.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//            make.centerY.equalTo(colorVI)
//        }
//
//        infoLab.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self)
//            make.top.equalTo(colorVI.snp.bottom).offset(20)
//        }
//
//        acrossLineVI.backgroundColor = UIColor(white: 0.8, alpha: 1)
//        acrossLineVI.snp.makeConstraints { (make) in
//            make.left.right.equalTo(coverView)
//            make.height.equalTo(0.5)
//            make.bottom.equalTo(coverView).offset(-40)
//        }
//
//        betweenLineVI.backgroundColor = acrossLineVI.backgroundColor
//        betweenLineVI.snp.makeConstraints { (make) in
//            make.centerX.equalTo(coverView)
//            make.width.equalTo(0.5)
//            make.bottom.equalTo(coverView)
//            make.top.equalTo(acrossLineVI.snp.bottom)
//        }
//
//        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        leftBtn.setTitleColor(CTColorHelper.gray_80(), for: .normal)
//        leftBtn.addTarget(self, action: #selector(clickLeftBtn), for: .touchUpInside)
//
//        leftBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(coverView)
//            make.right.equalTo(betweenLineVI.snp.left)
//            make.bottom.equalTo(coverView)
//            make.top.equalTo(betweenLineVI)
//        }
//
//        rightBtn.titleLabel?.font = leftBtn.titleLabel?.font
//        rightBtn.setTitleColor(CTColorHelper.golden_CF(), for: .normal)
//        rightBtn.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
//
//        rightBtn.snp.makeConstraints { (make) in
//            make.right.equalTo(coverView)
//            make.left.equalTo(betweenLineVI.snp.right)
//            make.bottom.equalTo(coverView)
//            make.top.equalTo(betweenLineVI)
//        }
//
//        titleLab.textColor = CTColorHelper.orange_FD()
//
//        titleLab.font = UIFont.systemFont(ofSize: 17)
//
//        infoLab.numberOfLines = 0
//
//        infoLab.preferredMaxLayoutWidth = coverWidth - 35
//
//        infoLab.textColor = CTColorHelper.blue_34()
//    }
//
//
//    fileprivate func setShadow() {
//        coverView.backgroundColor = UIColor.white
//
//        coverView.layer.cornerRadius = 5
//
//        coverView.layer.shadowColor = CTColorHelper.golden_D9().cgColor
//
//        coverView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
//
//        coverView.layer.shadowOpacity = 0.8
//
//        coverView.layer.shadowRadius = 6
//
//        //coverView.layer.borderColor = UIColor.blue.cgColor
//    }
//
//
//    @objc private func clickLeftBtn(_ sender: UIButton) {
//        CTRemarkTool.dismiss()
//        mClosure!(sender.tag)
//    }
//
//
//    @objc private func clickRightBtn(_ sender: UIButton) {
//        CTRemarkTool.dismiss()
//        mClosure!(sender.tag)
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    public static func setColorLayers(width: CGFloat) -> UIView {
//        let bgView = UIView(frame: CGRect.init(x: 0, y: 5, width: width, height: 30))
//        let colors = [UIColor(white: 0.6, alpha: 0.1).cgColor,
//                      CTColorHelper.golden_D9().cgColor,
//                      UIColor(white: 0.6, alpha: 0.1).cgColor,] as [Any]
//
//        let layer = CAGradientLayer()
//        layer.frame = bgView.bounds
//        layer.colors = colors
//        layer.startPoint = CGPoint(x: 0, y: 0)
//        layer.endPoint = CGPoint(x: 1, y: 0)
//        bgView.layer.addSublayer(layer)
//        return bgView
//    }
//
//}
//
//
//class CTSelPictureHUD: UIView {
//
//    var mClosure: ((NSInteger)->())?
//
//    var cancelClosure: (()->())?
//
//    var mActionInfos: [String] = []
//
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = UIColor(white: 0, alpha: 0.2)
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    func setItemInfo() {
//        let height: CGFloat = 38
//
//        let cancelBtn = UIButton()
//        cancelBtn.backgroundColor = UIColor(white: 0, alpha: 0.5)
//        cancelBtn.setTitle("取 消", for: .normal)
//        cancelBtn.setTitleColor(UIColor.white, for: .normal)
//        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//
//        addSubview(cancelBtn)
//
//        let bootomHeight: CGFloat = SafeAreaInfo.0 ? 20 : 10
//
//        cancelBtn.snp.makeConstraints { (make) in
//            make.bottom.equalTo(self).offset(-bootomHeight)
//            make.centerX.equalTo(self)
//            make.width.equalTo(SafeAreaInfo.1/3)
//            make.height.equalTo(height)
//        }
//
//        cancelBtn.layer.cornerRadius = height/2
//        cancelBtn.layer.masksToBounds = true
//        cancelBtn.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
//        cancelBtn.transform = CGAffineTransform(translationX: 0, y: 120)
//
//        for (index, info) in mActionInfos.enumerated() {
//            let btn = UIButton()
//            btn.backgroundColor = cancelBtn.backgroundColor
//            btn.setTitle(info, for: .normal)
//            btn.setTitleColor(UIColor.white, for: .normal)
//            btn.titleLabel?.font = cancelBtn.titleLabel?.font
//            btn.transform = CGAffineTransform(translationX: 0, y: 120)
//            btn.tag = mActionInfos.count - 1 - index
//
//            addSubview(btn)
//
//            let bottom = (height + 8.0) * CGFloat(index + 1) + bootomHeight
//
//            btn.snp.makeConstraints { (make) in
//                make.centerX.width.equalTo(cancelBtn)
//                make.height.equalTo(height)
//                make.bottom.equalTo(self).offset(-bottom)
//            }
//
//            btn.layer.cornerRadius = height/2
//            btn.layer.masksToBounds = true
//
//            UIView.animate(withDuration: 0.35) {
//                btn.transform = CGAffineTransform.identity
//            }
//
//            btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
//        }
//
//        UIView.animate(withDuration: 0.30) {
//            cancelBtn.transform = CGAffineTransform.identity
//        }
//    }
//
//
//    @objc private func clickCancel()  {
//        let window = UIApplication.shared.keyWindow
//        let currentView = window?.viewWithTag(CTRemarkTool_Tag)
//
//        if currentView != nil {
//            UIView.animate(withDuration: 0.3) {
//                currentView?.alpha = 0
//            } completion: { (_) in
//                self.cancelClosure?()
//                currentView?.removeFromSuperview()
//            }
//        }
//    }
//
//
//    @objc private func clickAction(btn: UIButton)  {
//        if mClosure != nil {
//            mClosure!(btn.tag)
//        }
//    }
//
//}
