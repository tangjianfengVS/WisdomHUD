//
//  Action.swift
//  WisdomHUDDemo
//
//  Created by tangjianfeng on 2021/12/23.
//  Copyright © 2021 All over the sky star. All rights reserved.
//

import UIKit

extension WisdomColorThemeStyle {
    
    static func getColor(themeStyle: WisdomColorThemeStyle)->(HUDColor:UIColor,
                                                              TitleColor:UIColor,
                                                              TextColor:UIColor,
                                                              TailColor:UIColor,
                                                              LayerColor:UIColor,
                                                              LineColor:UIColor){
        var hudColor = UIColor.white
        var titleColor = UIColor.white
        var textColor = UIColor.white
        var tailColor = UIColor.white
        var layerColor = UIColor.white
        var lineColor = UIColor(white: 0.94, alpha: 1)
        switch themeStyle {
        case .light:
            titleColor = UIColor(white: 0.2, alpha: 1)
            textColor = UIColor(white: 0.2, alpha: 1)
            tailColor = UIColor(white: 0.2, alpha: 1)
            layerColor = .gray
        case .dark:
            hudColor = UIColor(white: 0, alpha: 0.9)
            titleColor = .wisdom_color(hex: "C0C0C0")
            textColor = .wisdom_color(hex: "C0C0C0")
            tailColor = .wisdom_color(hex: "C0C0C0")
            lineColor = UIColor(white: 0.18, alpha: 1)
        }
        return (hudColor,titleColor,textColor,tailColor,layerColor,lineColor)
    }
}


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
        label.font = UIFont.systemFont(ofSize: 13.5)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let titleLineVI: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return vi
    }()
    
    fileprivate let hitView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.90, alpha: 1)
        return vi
    }()
    
    fileprivate let tailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    fileprivate let acrossLineVI: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return vi
    }()
    
    fileprivate let betweenLineVI: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return vi
    }()
    
    fileprivate lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(clickLeftBtn(_:)), for: .touchUpInside)
        return btn
    }()

    fileprivate lazy var rightBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(clickRightBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate var hitBottomConstraint: NSLayoutConstraint?
    
    fileprivate var titleTopConstraint: NSLayoutConstraint?

    private let actionClosure: (String,WisdomActionValueStyle)->(Bool)
    
    init(title: String, text: String, label: String?, leftAction: String?, rightAction: String, actionClosure: @escaping (String, WisdomActionValueStyle)->(Bool)) {
        self.actionClosure = actionClosure
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

        wisdom_addConstraint(with: titleLabel,
                             topView: self,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
        
        wisdom_addConstraint(with: titleLineVI,
                             topView: self,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 0))

        titleLineVI.wisdom_addConstraint(width: -1, height: 1)
        
        let titleConstraint = NSLayoutConstraint(item: textLabel,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: titleLineVI,
                                                    attribute: .bottom,
                                                    multiplier: 1.0,
                                                    constant: 15)
        titleTopConstraint = titleConstraint
        addConstraint(titleConstraint)
        addConstraint(NSLayoutConstraint(item: textLabel,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 18))
        addConstraint(NSLayoutConstraint(item: textLabel,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: -18))
        
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
        let hitConstraint = NSLayoutConstraint(item: hitView,
                                               attribute: .bottom,
                                               relatedBy: .equal,
                                               toItem: acrossLineVI,
                                               attribute: .bottom,
                                               multiplier: 1.0,
                                               constant: -20)
        hitBottomConstraint = hitConstraint
        addConstraint(hitConstraint)
        addConstraint(NSLayoutConstraint(item: hitView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: textLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 18))
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

    @objc private func clickLeftBtn(_ sender: UIButton) {
        if actionClosure(sender.titleLabel?.text ?? "", .left) {
            if superview != nil {
                WisdomHUDCore.dismissAction()
            }
        }
    }
    
    @objc private func clickRightBtn(_ sender: UIButton) {
        if actionClosure(sender.titleLabel?.text ?? "", .right) {
            if superview != nil {
                WisdomHUDCore.dismissAction()
            }
        }
    }
}

extension WisdomHUDActionView: WisdomHUDActionContextable {
    
    func setLeftAction(textColor: UIColor?, textFont: UIFont?)->Self {
        if let text_Color = textColor {
            leftBtn.setTitleColor(text_Color, for: .normal)
        }
        if let text_Font = textFont {
            leftBtn.titleLabel?.font = text_Font
        }
        return self
    }
    
    func setRightAction(textColor: UIColor?, textFont: UIFont?)->Self {
        if let text_Color = textColor {
            rightBtn.setTitleColor(text_Color, for: .normal)
        }
        if let text_Font = textFont {
            rightBtn.titleLabel?.font = text_Font
        }
        return self
    }
    
    func setTextFont(font: UIFont)->Self {
        textLabel.font = font
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 2.5
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.paragraphStyle: paraph]
        textLabel.attributedText = NSAttributedString(string: textLabel.text ?? "", attributes: attributes)
        textLabel.sizeToFit()
        return self
    }
    
    func setTextColor(color: UIColor)->Self {
        textLabel.textColor = color
        return self
    }
    
    func setTextAlignment(alignment: NSTextAlignment)->Self {
        textLabel.textAlignment = alignment
        return self
    }
    
    func setLabelFont(font: UIFont)->Self {
        tailLabel.font = font
        return self
    }
    
    func setLabelColor(color: UIColor)->Self {
        tailLabel.textColor = color
        return self
    }
}

class WisdomHUDActionThemeView: WisdomHUDActionView {
    
    override init(title: String, text: String, label: String?, leftAction: String?, rightAction: String, actionClosure: @escaping (String, WisdomActionValueStyle)->(Bool)) {
        super.init(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction, actionClosure: actionClosure)
        titleLabel.text = title
        textLabel.text = text
        tailLabel.text = label
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 2.5
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.5, weight: .regular),
                          NSAttributedString.Key.paragraphStyle: paraph]
        textLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        textLabel.sizeToFit()
        
        if titleLabel.text?.count == 0 {
            titleLabel.text = " "
        }
        
        if text.count == 0 {
            titleTopConstraint?.constant = 2
        }
        
        if label?.count == 0 {
            hitView.isHidden = true
            hitBottomConstraint?.constant = -5
        }
        
        betweenLineVI.isHidden = leftAction == nil
    }
    
    func setThemeStyle(themeStyle: WisdomColorThemeStyle){
        let colors = WisdomColorThemeStyle.getColor(themeStyle: themeStyle)
        backgroundColor = colors.HUDColor
        titleLabel.textColor = colors.TitleColor
        textLabel.textColor = colors.TextColor
        hitView.backgroundColor = colors.TailColor.withAlphaComponent(0.3)
        tailLabel.textColor = colors.TailColor
        leftBtn.setTitleColor(colors.TitleColor, for: .normal)
        rightBtn.setTitleColor(colors.TitleColor, for: .normal)
        titleLineVI.backgroundColor = colors.LineColor
        acrossLineVI.backgroundColor = colors.LineColor
        betweenLineVI.backgroundColor = colors.LineColor
        
        layer.cornerRadius = 6
        layer.shadowOffset = CGSize.init(width: 0, height: 0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 6
        layer.shadowColor = colors.LayerColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
