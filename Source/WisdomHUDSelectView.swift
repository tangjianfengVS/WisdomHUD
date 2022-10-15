//
//  WisdomActionView.swift
//  WisdomHUDDemo
//
//  Created by tangjianfeng on 2021/12/23.
//  Copyright © 2021 All over the sky star. All rights reserved.
//

import UIKit


struct WisdomActionThemeModel {
    
//    let themeStyle: WisdomLayerThemeStyle
//    
//    let titleColor: UIColor   // 标题
//    let infoClor: UIColor     // 详情
//    let tailClor: UIColor     // 尾签
//
//    let rightBtnClor: UIColor  // 确认
//    let topBarColor: UIColor   // Bar
//    let layerColor: UIColor    // 阴影
//    
//    init(themeStyle: WisdomLayerThemeStyle){
//        self.themeStyle = themeStyle
//        
//        switch themeStyle{
//        case .snowWhite:
//            titleColor = UIColor.white
//            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
//            layerColor = topBarColor
//            rightBtnClor = topBarColor
// 
//            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.9)
//            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
//        case .yigou:
//            titleColor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
//            topBarColor = UIColor.white
//            layerColor = topBarColor
//            rightBtnClor = topBarColor
// 
//            infoClor = UIColor(white: 1, alpha: 0.9)
//            tailClor = UIColor.white
//        case .blue:
//            titleColor = UIColor.white
//            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "0000FF", alpha: 0.82)
//            layerColor = topBarColor
//            rightBtnClor = topBarColor
//            
//            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.9)
//            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
//        case .dodgerBlue:
//            titleColor = UIColor.white
//            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "1E90FF")
//            layerColor = topBarColor
//            rightBtnClor = topBarColor
//            
//            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.9)
//            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
//        case .golden:  
//            titleColor = UIColor.white
//            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "D9D919")
//            layerColor = topBarColor
//            rightBtnClor = UIColor.wisdom_SCHEXCOLOR(hex: "E3CF57")
//            
//            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.9)
//            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
//        case .red:
//            titleColor = UIColor.white
//            topBarColor = UIColor.wisdom_SCHEXCOLOR(hex: "FF0000", alpha: 0.82)
//            layerColor = topBarColor
//            rightBtnClor = topBarColor
//            
//            infoClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E",alpha: 0.9)
//            tailClor = UIColor.wisdom_SCHEXCOLOR(hex: "34495E")
//        }
//    }
//}
//
//
//
//class WisdomActionView: UIView {
//    
//    private let titleLab = UILabel()
//
//    private let infoLab = UILabel()
//    
//    private let middleVI = UIView()
//    
//    private let tailLab = UILabel()
//
//    private let acrossLineVI = UIView()
//
//    private let betweenLineVI = UIView()
//
//    private let leftBtn = UIButton()
//
//    private let rightBtn = UIButton()
//    
//    private let hitView = UIView()
//    
//    private let themeModel: WisdomActionThemeModel
//
//    private let actionHandler: (String, NSInteger)->()
//    
//    
//    init(title: String,
//         infoText: String,
//         tailText: String,
//         actionList: [String],
//         themeStyle: WisdomLayerThemeStyle,
//         actionHandler: @escaping (String, NSInteger)->()) {
//    
//        self.themeModel = WisdomActionThemeModel(themeStyle: themeStyle)
//        self.actionHandler = actionHandler
//        super.init(frame: .zero)
//        
//        backgroundColor = themeStyle == .yigou ? UIColor(white: 0, alpha: 0.70) : UIColor.white
//
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        titleLab.translatesAutoresizingMaskIntoConstraints = false
//        
//        infoLab.translatesAutoresizingMaskIntoConstraints = false
//        
//        tailLab.translatesAutoresizingMaskIntoConstraints = false
//        
//        acrossLineVI.translatesAutoresizingMaskIntoConstraints = false
//        
//        betweenLineVI.translatesAutoresizingMaskIntoConstraints = false
//        
//        leftBtn.translatesAutoresizingMaskIntoConstraints = false
//        
//        rightBtn.translatesAutoresizingMaskIntoConstraints = false
//    
//        middleVI.translatesAutoresizingMaskIntoConstraints = false
//        
//        hitView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let width: CGFloat = IsSmallScreen ? 260 : 270
//        
//        let height: CGFloat = width*0.75
//        
//        let colorVI = WisdomLayerCoverView.createColorLayerView(width: width, height:32, color: themeModel.topBarColor)
//
//        addSubview(colorVI)
//
//        addSubview(titleLab)
//
//        addSubview(infoLab)
//        
//        addSubview(tailLab)
//
//        addSubview(acrossLineVI)
//        
//        addSubview(betweenLineVI)
//        
//        addSubview(leftBtn)
//        
//        addSubview(rightBtn)
//        
//        addSubview(middleVI)
//        
//        addSubview(hitView)
//    
//        addConstraint(with: titleLab,
//                      topView: colorVI,
//                      leftView: self,
//                      bottomView: colorVI,
//                      rightView: self,
//                      edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//
//        // info
//        addConstraint(with: infoLab,
//                      topView: colorVI,
//                      leftView: self,
//                      bottomView: nil,
//                      rightView: self,
//                      edgeInset: UIEdgeInsets(top: 50, left: 20, bottom: -22, right: -20))
//        
//        
//        acrossLineVI.addConstraint(width: 0, height: 1)
//        
//        addConstraint(with: middleVI,
//                      topView: nil,
//                      leftView: infoLab,
//                      bottomView: infoLab,
//                      rightView: infoLab,
//                      edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        
//        // tail
//        addConstraint(with: tailLab,
//                      topView: middleVI,
//                      leftView: hitView,
//                      bottomView: nil,
//                      rightView: middleVI,
//                      edgeInset: UIEdgeInsets(top: 7, left: 15, bottom: 0, right: 0))
//
//        // acrossLine
//        acrossLineVI.addConstraint(width: 0, height: 0.5)
//
//        addConstraint(with: acrossLineVI,
//                      topView: nil,
//                      leftView: self,
//                      bottomView: self,
//                      rightView: self,
//                      edgeInset: UIEdgeInsets(top: 20, left: 0, bottom: -40, right: 0))
//        
//        // betweenLine
//        betweenLineVI.addConstraint(width: 0.5, height: 0)
//        
//        addConstraint(toCenterX: betweenLineVI, toCenterY: nil)
//        
//        addConstraint(with: betweenLineVI,
//                      topView: acrossLineVI,
//                      leftView: nil,
//                      bottomView: self,
//                      rightView: nil,
//                      edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        
//        // hit
//        hitView.addConstraint(width: 7, height: 7)
//        
//        addConstraint(with: hitView,
//                      topView: tailLab,
//                      leftView: self,
//                      bottomView: nil,
//                      rightView: nil,
//                      edgeInset: UIEdgeInsets(top: 4, left: 20, bottom: 0, right: 0))
//        
//        addConstraint(width: width, height: height)
//        
//        middleVI.backgroundColor = UIColor.clear
//        
//        titleLab.text = title
//        
//        titleLab.textColor = themeModel.titleColor
//        
//        titleLab.textAlignment = .center
//        
//        titleLab.font = UIFont.boldSystemFont(ofSize: 15)
//        
//        titleLab.sizeToFit()
//        
//        
//        let paraph = NSMutableParagraphStyle()
//        paraph.lineSpacing = 3 //行间距设置
//
//        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
//                          NSAttributedString.Key.paragraphStyle: paraph]
//        infoLab.attributedText = NSAttributedString(string: infoText, attributes: attributes)
//        
//        infoLab.textAlignment = .left
//        
//        infoLab.backgroundColor = UIColor.clear
//        
//        infoLab.numberOfLines = 4
//        
//        infoLab.lineBreakMode = .byTruncatingTail
//
//        infoLab.textColor = themeModel.infoClor
//        
//        infoLab.sizeToFit()
//        
//        
//        tailLab.text = tailText
//        
//        tailLab.font = UIFont.boldSystemFont(ofSize: 14)
//        
//        tailLab.numberOfLines = 1
//        
//        tailLab.lineBreakMode = .byTruncatingTail
//
//        tailLab.textColor = themeModel.tailClor
//        
//        tailLab.sizeToFit()
//        
//        acrossLineVI.backgroundColor = UIColor(white: 0.85, alpha: 1)
//        
//        betweenLineVI.backgroundColor = acrossLineVI.backgroundColor
//        
//        
//        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        
//        let color = themeStyle == .yigou ? UIColor(white: 1, alpha: 0.8) : UIColor.wisdom_SCHEXCOLOR(hex: "34495E", alpha: 0.8)
//        leftBtn.setTitleColor(color, for: .normal)
//        
//        leftBtn.addTarget(self, action: #selector(clickActionBtn), for: .touchUpInside)
//        
//        rightBtn.titleLabel?.font = leftBtn.titleLabel?.font
//        
//        rightBtn.setTitleColor(themeModel.rightBtnClor, for: .normal)
//        
//        rightBtn.addTarget(self, action: #selector(clickActionBtn), for: .touchUpInside)
//        
//        hitView.backgroundColor = themeModel.rightBtnClor
//        
//        hitView.layer.masksToBounds = true
//        
//        hitView.layer.cornerRadius = 7/2
//        
//        setactionList(actionList: actionList)
//    }
//    
//    
//    private func setactionList(actionList: [String]){
//
//        if actionList.count >= 2 {
//            betweenLineVI.isHidden = false
//            
//            leftBtn.setTitle(actionList.first!, for: .normal)
//            leftBtn.setTitle(actionList.first!, for: .highlighted)
//            leftBtn.tag = 0
//            leftBtn.isHidden = false
//            
//            rightBtn.setTitle(actionList[1], for: .normal)
//            rightBtn.setTitle(actionList.first!, for: .highlighted)
//            rightBtn.tag = 1
//            rightBtn.isHidden = false
//            
//            addConstraint(with: leftBtn,
//                          topView: acrossLineVI,
//                          leftView: self,
//                          bottomView: self,
//                          rightView: betweenLineVI,
//                          edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//            
//            addConstraint(with: rightBtn,
//                          topView: acrossLineVI,
//                          leftView: betweenLineVI,
//                          bottomView: self,
//                          rightView: self,
//                          edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//            
//        }else if actionList.count == 1{
//            betweenLineVI.isHidden = true
//            
//            leftBtn.isHidden = true
//            leftBtn.setTitle("", for: .highlighted)
//            
//            rightBtn.isHidden = false
//            rightBtn.setTitle(actionList.first, for: .normal)
//            rightBtn.setTitle(actionList.first!, for: .highlighted)
//            rightBtn.tag = 0
//            
//            addConstraint(with: rightBtn,
//                          topView: acrossLineVI,
//                          leftView: self,
//                          bottomView: self,
//                          rightView: self,
//                          edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }else {
//            betweenLineVI.isHidden = true
//            
//            leftBtn.isHidden = true
//            leftBtn.setTitle("", for: .highlighted)
//            
//            rightBtn.isHidden = true
//            rightBtn.setTitle("", for: .highlighted)
//        }
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//
//    @objc private func clickActionBtn(_ sender: UIButton) {
//        WisdomHUD.dismiss()
//        
//        let text: String = (sender.titleLabel == nil) ? "" : sender.titleLabel!.text!
//        
//        actionHandler(text, sender.tag)
//    }
//    
//
//    fileprivate func setShadow() {
//        layer.cornerRadius = 6
//
//        layer.shadowOffset = CGSize.init(width: 0, height: 0)
//
//        layer.shadowOpacity = 0.5
//
//        layer.shadowRadius = 6
//        
//        layer.shadowColor = themeModel.layerColor.cgColor
//    }
//
//}
//
//
//
//extension WisdomActionView: WisdomHUDProtocol {
//    
//    /* Action HUD */
//    static func showAction(title: String,
//                           infoText: String,
//                           tailText: String,
//                           actionList: [String],
//                           themeStyle: WisdomLayerThemeStyle,
//                           actionHandler: @escaping (String, NSInteger)->()) {
//        DispatchQueue.main.async {
//            let actionView = WisdomActionView(title: title,
//                                              infoText: infoText,
//                                              tailText: tailText,
//                                              actionList: actionList,
//                                              themeStyle: themeStyle,
//                                              actionHandler: actionHandler)
//
//            actionView.addToWindow()
//
//            actionView.setShadow()
//            
//            actionView.keepTime()
//        }
//    }
//    
//    
//    /* 展示 */
//    func addToWindow() {
//        let window = WisdomHUD.getScreenWindow()
//        
//        if window != nil {
//            let currentView = window!.viewWithTag(WisdomHUDWindowTag)
//            //let offsetY = window!.bounds.size.height/10.0
//            
//            if let hudCoverVI = currentView as? WisdomLayerCoverView {
//                for view in hudCoverVI.subviews {
//                    view.removeFromSuperview()
//                }
//                
//                hudCoverVI.addSubview(self)
//                
//                hudCoverVI.addConstraint(toCenterX: self, toCenterY: self)
//            }else {
//                let coverVI = WisdomLayerCoverView()
//                
//                coverVI.translatesAutoresizingMaskIntoConstraints = false
//                
//                coverVI.backgroundColor = UIColor(white: 0, alpha: 0.35)
//                
//                coverVI.tag = WisdomHUDWindowTag
//               
//                window!.addSubview(coverVI)
//                
//                window!.addConstraint(with: coverVI,
//                                   topView: window!,
//                                  leftView: window!,
//                                bottomView: window!,
//                                 rightView: window!,
//                                 edgeInset: UIEdgeInsets.zero)
//                
//                coverVI.addSubview(self)
//                
//                coverVI.addConstraint(toCenterX: self, toCenterY: self)
//            }
//        }
//    }
//    
//    
//    func keepTime() {
//        
//    }
//    
//    
//    func animateEnd() {
//        
//    }
    
}
