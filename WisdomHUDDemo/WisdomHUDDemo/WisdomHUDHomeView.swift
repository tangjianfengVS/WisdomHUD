//
//  WisdomHUDHomeView.swift
//  WisdomHUDDemo
//
//  Created by jianfeng tang on 2022/10/15.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit


class WisdomCustomNextCell: UITableViewCell {
    
    private var loadingStyle: WisdomLoadingStyle?
    
    private var textPlaceStyle: WisdomTextPlaceStyle?
    
    let nextView = WisdomCustomNextView(frame: .zero)
    
    private var leftView: UIView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(nextView)
        
        nextView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-1)
            make.left.equalTo(contentView).offset(0)
            make.right.equalTo(contentView).offset(-0)
        }
        
        nextView.layer.masksToBounds = true
        nextView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    func setTitle(hudStyle: WisdomHUDStyle, loadingStyle: WisdomLoadingStyle?, progressStyle: WisdomProgressStyle?, textPlaceStyle: WisdomTextPlaceStyle?) {
        nextView.infoLabel.text = "\(hudStyle.self)"
        leftView?.removeFromSuperview()
        leftView = nil
        var itemWidth: CGFloat = 24
        var leftSpec: CGFloat = 35
        switch hudStyle {
        case .succes:
            leftView = WisdomHUDSuccessView(size: 24, barStyle: sceneBarStyle)
            (leftView as? WisdomHUDSuccessView)?.beginAnimation(isRepeat: false)
        case .error:
            leftView = WisdomHUDErrorView(size: 24, barStyle: sceneBarStyle)
            (leftView as? WisdomHUDErrorView)?.beginAnimation(isRepeat: false)
        case .warning:
            leftView = WisdomHUDWarningView(size: 24, barStyle: sceneBarStyle)
            (leftView as? WisdomHUDWarningView)?.beginAnimation(isRepeat: false)
        default: break
        }
        
        switch loadingStyle {
        case .system:
            nextView.infoLabel.text = "\(hudStyle.self)"+".system"
        
            leftView = WisdomHUDIndicatorView(size: 24, barStyle: sceneBarStyle)
        case .rotate:
            nextView.infoLabel.text = "\(hudStyle.self)"+".rotate"
            
            leftView = WisdomHUDRotateView(size: 24, barStyle: sceneBarStyle)
        case .progressArc:
            nextView.infoLabel.text = "\(hudStyle.self)"+".progressArc"
            
            leftView = WisdomHUDProgressArcView(size: 24, barStyle: sceneBarStyle)
        case .tadpoleArc:
            nextView.infoLabel.text = "\(hudStyle.self)"+".tadpoleArc"
            
            leftView = WisdomHUDTadpoleArcView(size: 24, barStyle: sceneBarStyle)
        case .chaseBall:
            nextView.infoLabel.text = "\(hudStyle.self)"+".chaseBall"
            
            leftView = WisdomHUDChaseBallView(size: 24, barStyle: sceneBarStyle)
        case .pulseBall:
            nextView.infoLabel.text = "\(hudStyle.self)"+".pulseBall"
            
            leftView = WisdomHUDPulseBallView(size: 24, barStyle: sceneBarStyle)
        case .pulseShape:
            nextView.infoLabel.text = "\(hudStyle.self)"+".pulseBall"
            
            leftView = WisdomHUDPulseShapeView(size: 24, barStyle: sceneBarStyle)
        default: break
        }
        
        switch progressStyle {
        case .circle:
            nextView.infoLabel.text = "\(hudStyle.self)"+".circle"
            itemWidth = 35
            leftSpec = 30
            leftView = WisdomHUDImageCircleView(size: itemWidth, barStyle: sceneBarStyle)
            (leftView as? WisdomHUDImageCircleView)?.setProgreValue(value: 60)
            (leftView as? WisdomHUDImageCircleView)?.setProgreColor(color: .systemPink)
            (leftView as? WisdomHUDImageCircleView)?.setProgreTextColor(color: .systemPink)
        case .linear:
            nextView.infoLabel.text = "\(hudStyle.self)"+".linear"
            itemWidth = 35
            leftSpec = 30
            leftView = WisdomHUDImageLinearView(size: itemWidth, barStyle: sceneBarStyle)
            (leftView as? WisdomHUDImageLinearView)?.setProgreValue(value: 60)
            (leftView as? WisdomHUDImageLinearView)?.setProgreColor(color: .systemPink)
            (leftView as? WisdomHUDImageLinearView)?.setProgreTextColor(color: .systemPink)
        default: break
        }
        
        switch sceneBarStyle {
        case .dark:
            nextView.backgroundColor = UIColor.black
            nextView.infoLabel.textColor = UIColor.white
            nextView.imageView.image = UIImage(named: "G_Next_Gray")
        case .light:
            nextView.backgroundColor = UIColor.white
            nextView.infoLabel.textColor = UIColor.black
            nextView.imageView.image = UIImage(named: "G_Next_Black")
        case .hide:
            nextView.backgroundColor = UIColor.black
            nextView.infoLabel.textColor = UIColor.white
            nextView.imageView.image = UIImage(named: "G_Next_Gray")
        }
        
        switch textPlaceStyle {
        case .center: nextView.infoLabel.text = "\(hudStyle.self)"+".center"
        case .bottom: nextView.infoLabel.text = "\(hudStyle.self)"+".bottom"
        default: break
        }
        
        if let vi = leftView {
            contentView.addSubview(vi)
            
            vi.snp.makeConstraints({ make in
                make.left.equalTo(nextView).offset(leftSpec)
                make.centerY.equalTo(contentView)
                make.width.height.equalTo(itemWidth)
            })
        }
    }
}


class WisdomCustomNextView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "G_Next_Gray"))

    let infoLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(infoLabel)
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-12)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// 下级图标-视图
class WisdomBarStyleView: UIView {
    
    let resultClosure: (WisdomSceneBarStyle)->()
    
    private var selBtn: UIButton?
    
    init(resultClosure: @escaping (WisdomSceneBarStyle)->()) {
        self.resultClosure = resultClosure
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
        var lastBtn: UIButton?
        
        for barStyle in WisdomSceneBarStyle.allCases {
            let btn = UIButton()
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            btn.addTarget(self, action: #selector(clickAction(btn:)), for: .touchUpInside)
            addSubview(btn)
            
            btn.snp.makeConstraints { make in
                make.top.bottom.equalTo(self)
                make.width.equalTo(40)
                make.height.equalTo(30)
                if let curBtn = lastBtn {
                    make.left.equalTo(curBtn.snp.right)
                }else {
                    make.left.equalTo(self)
                }
            }
            update(selBtn: btn, barStyle: barStyle)
            btn.tag = barStyle.rawValue
            lastBtn = btn
            
            if barStyle == sceneBarStyle {
                btn.backgroundColor = UIColor.systemPink
                btn.setTitleColor(UIColor.white, for: .normal)
                selBtn = btn
            }
        }
        
        if let curBtn = lastBtn {
            snp.makeConstraints { make in
                make.right.equalTo(curBtn)
            }
        }
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.1
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update(selBtn: UIButton, barStyle: WisdomSceneBarStyle) {
        switch barStyle {
        case .dark:
            selBtn.setTitle(".dark", for: .normal)
            selBtn.backgroundColor = UIColor.black
            selBtn.setTitleColor(UIColor.white, for: .normal)
        case .light:
            selBtn.setTitle(".light", for: .normal)
            selBtn.backgroundColor = UIColor.white
            selBtn.setTitleColor(UIColor.black, for: .normal)
        case .hide:
            selBtn.setTitle(".hide", for: .normal)
            selBtn.backgroundColor = UIColor.black
            selBtn.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @objc private func clickAction(btn: UIButton) {
        if let oldBtn = selBtn, let barStyle = WisdomSceneBarStyle(rawValue: oldBtn.tag) {
            update(selBtn: oldBtn, barStyle: barStyle)
        }
        if let barStyle = WisdomSceneBarStyle(rawValue: btn.tag) {
            btn.backgroundColor = UIColor.systemPink
            btn.setTitleColor(UIColor.white, for: .normal)
            resultClosure(barStyle)
        }
        selBtn = btn
    }
}
