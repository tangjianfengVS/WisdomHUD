//
//  WisdomActionView.swift
//  WisdomHUDDemo
//
//  Created by tangjianfeng on 2021/12/23.
//  Copyright © 2021 All over the sky star. All rights reserved.
//

import UIKit


//struct WisdomActionThemeModel {
    
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


class WisdomHUDActionView: UIView {
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()

    fileprivate let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLineVI: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return vi
    }()
    
    fileprivate let hitView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return vi
    }()
    
    fileprivate let tailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let acrossLineVI: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return vi
    }()
    
    private let betweenLineVI: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return vi
    }()
    
    private let leftBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return btn
    }()

    private let rightBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return btn
    }()
    
//    private let themeModel: WisdomActionThemeModel

    private let actinClosure: (String,WisdomActionValueStyle)->(Bool)
    
    init(title: String, text: String, label: String?, leftAction: String?, rightAction: String, actinClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) {
        self.actinClosure = actinClosure
        super.init(frame: .zero)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLineVI)
        titleLineVI.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(acrossLineVI)
        acrossLineVI.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(betweenLineVI)
        betweenLineVI.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hitView)
        hitView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tailLabel)
        tailLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let height: CGFloat = width*0.75
//
//        let colorVI = UIView()//WisdomLayerCoverView.createColorLayerView(width: width, height:32, color: themeModel.topBarColor)

        wisdom_addConstraint(with: titleLabel,
                             topView: self,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        wisdom_addConstraint(with: titleLineVI,
                             topView: self,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0))

        titleLineVI.wisdom_addConstraint(width: -1, height: 1)

        addConstraint(NSLayoutConstraint(item: textLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: titleLineVI,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 15))
        addConstraint(NSLayoutConstraint(item: textLabel,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 20))
        addConstraint(NSLayoutConstraint(item: textLabel,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: -20))
        
        wisdom_addConstraint(with: acrossLineVI,
                             topView: nil,
                             leftView: self,
                             bottomView: self,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: -46, right: 0))

        acrossLineVI.wisdom_addConstraint(width: -1, height: 1)
        
        wisdom_addConstraint(with: betweenLineVI,
                             topView: acrossLineVI,
                             leftView: nil,
                             bottomView: self,
                             rightView: nil,
                             edgeInset: UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0))
        
        wisdom_addConstraint(toCenterX: betweenLineVI, toCenterY: nil)

        betweenLineVI.wisdom_addConstraint(width: 1, height: -1)
    
        // hit
        hitView.wisdom_addConstraint(width: 7, height: 7)

        addConstraint(NSLayoutConstraint(item: hitView,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: textLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: hitView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: acrossLineVI,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: -30))
        addConstraint(NSLayoutConstraint(item: hitView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: textLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 20))
        hitView.layer.masksToBounds=true
        hitView.layer.cornerRadius=7/2
        
        addConstraint(NSLayoutConstraint(item: tailLabel,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: hitView,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 10))
        addConstraint(NSLayoutConstraint(item: tailLabel,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: textLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tailLabel,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: hitView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
        setactionList(leftAction: leftAction, rightAction: rightAction)
    }
    
    private func setactionList(leftAction: String?, rightAction: String){
        leftBtn.removeFromSuperview()
        rightBtn.removeFromSuperview()
        
        addSubview(rightBtn)
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        rightBtn.setTitle(rightAction, for: .normal)
        
        var leftView: UIView = self
        
        if let action = leftAction {
            leftView = betweenLineVI
            
            addSubview(leftBtn)
            leftBtn.translatesAutoresizingMaskIntoConstraints = false
            leftBtn.setTitle(action, for: .normal)
            
            wisdom_addConstraint(with: leftBtn,
                                 topView: acrossLineVI,
                                 leftView: self,
                                 bottomView: self,
                                 rightView: betweenLineVI,
                                 edgeInset: UIEdgeInsets(top: 1, left: 5, bottom: 0, right: -5))
        }
        
        wisdom_addConstraint(with: rightBtn,
                             topView: acrossLineVI,
                             leftView: leftView,
                             bottomView: self,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: -1, left: 5, bottom: 0, right: -5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func clickActionBtn(_ sender: UIButton) {
        //WisdomHUD.dismiss()
        
        //let text: String = (sender.titleLabel == nil) ? "" : sender.titleLabel!.text!
        
//        actionHandler(text, sender.tag)
    }
    
    func setShadow() {
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize.init(width: 0, height: 0)
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 6
//        layer.shadowColor = themeModel.layerColor.cgColor
    }
}

class WisdomHUDActionThemeView: WisdomHUDActionView {
    
    init(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actinClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) {
        super.init(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, actinClosure: actinClosure)
        titleLabel.text = title
        textLabel.text = text
        tailLabel.text = label
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 3
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.paragraphStyle: paraph]
        textLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        textLabel.sizeToFit()
        
        if titleLabel.text?.count == 0 {
            titleLabel.text = " "
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
