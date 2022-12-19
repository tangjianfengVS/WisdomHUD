//
//  WisdomHUDLogView.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/17.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

private var logView: WisdomHUDLogView?

class WisdomHUDLogView: UIView {
    
    static var isOpen = false
    
    private let itemWidth: CGFloat = 25
    private let maxWidth: CGFloat = 414.0
    private let maxHeight: CGFloat = 896.0-20.0
    private lazy var half_height: CGFloat = UIScreen.main.bounds.height*0.5>maxHeight ? maxHeight:UIScreen.main.bounds.height*0.5
    
    let scrollView = UIScrollView()
    let textLabel = UILabel()
    
    private(set) lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=1
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: itemWidth/3, y: itemWidth/3))
        path.addLine(to: CGPoint(x: itemWidth/3*2, y: itemWidth/3*2))
        path.move(to: CGPoint(x: itemWidth/3, y: itemWidth/3*2))
        path.addLine(to: CGPoint(x: itemWidth/3*2, y: itemWidth/3))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.gray.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private(set) lazy var sizeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11.5)
        button.setTitle("size", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.addTarget(self, action: #selector(clickSizeBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=1
        return button
    }()
    
    private(set) lazy var bottomBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickBottomBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=1
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: itemWidth/5, y: itemWidth/2))
        path.addLine(to: CGPoint(x: itemWidth/2, y: itemWidth/5*4))
        path.move(to: CGPoint(x: itemWidth/2, y: itemWidth/5*4))
        path.addLine(to: CGPoint(x: itemWidth/5*4, y: itemWidth/2))
        
        path.move(to: CGPoint(x: itemWidth/3*1.1, y: itemWidth/4))
        path.addLine(to: CGPoint(x: itemWidth/3*1.1, y: itemWidth/3*2))
        path.move(to: CGPoint(x: itemWidth/3*2*0.94, y: itemWidth/4))
        path.addLine(to: CGPoint(x: itemWidth/3*2*0.94, y: itemWidth/3*2))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.gray.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private(set) lazy var leftBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickLeftBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=1
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: itemWidth/2, y: itemWidth/5))
        path.addLine(to: CGPoint(x: itemWidth/5, y: itemWidth/2))
        path.move(to: CGPoint(x: itemWidth/5, y: itemWidth/2))
        path.addLine(to: CGPoint(x: itemWidth/2, y: itemWidth/5*4))
        
        path.move(to: CGPoint(x: itemWidth/5, y: itemWidth/2))
        path.addLine(to: CGPoint(x: itemWidth/5*4, y: itemWidth/2))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.gray.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private(set) lazy var rightBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.gray.cgColor
        button.layer.borderWidth=1

        let path = UIBezierPath()
        path.move(to: CGPoint(x: itemWidth/2, y: itemWidth/5))
        path.addLine(to: CGPoint(x: itemWidth/5*4, y: itemWidth/2))
        path.move(to: CGPoint(x: itemWidth/5*4, y: itemWidth/2))
        path.addLine(to: CGPoint(x: itemWidth/2, y: itemWidth/5*4))
        
        path.move(to: CGPoint(x: itemWidth/5, y: itemWidth/2))
        path.addLine(to: CGPoint(x: itemWidth/5*4, y: itemWidth/2))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.gray.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private(set) lazy var heightConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: half_height)
        return constraint
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        sizeBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomBtn.translatesAutoresizingMaskIntoConstraints = false
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        addSubview(closeBtn)
        addSubview(sizeBtn)
        addSubview(bottomBtn)
        addSubview(rightBtn)
        addSubview(leftBtn)
        scrollView.addSubview(textLabel)

        wisdom_addConstraint(with: scrollView,
                             topView: self,
                             leftView: self,
                             bottomView: self,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 10, left: 0, bottom: -itemWidth-5, right: 0))

        wisdom_addConstraint(with: textLabel,
                             topView: scrollView,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8))
        
        wisdom_addConstraint(with: closeBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: self,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: -5, right: -15))
        
        closeBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: sizeBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: closeBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        sizeBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: bottomBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: sizeBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        bottomBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: rightBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: bottomBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        rightBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: leftBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: rightBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        leftBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        textLabel.text = "【Initialization】"
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 13.5)
        textLabel.textAlignment = .left

        textLabel.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: bounds.size.width, height: textLabel.frame.maxY+10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String, textColor: UIColor){
        textLabel.text = (textLabel.text ?? "")+"\n"+text
        
        var attributedText = textLabel.attributedText
//        if attributedText == nil {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 3
            attributedText = NSAttributedString(string: textLabel.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: style])
//        }
//        var mutable = NSMutableAttributedString()
//        if let attri = textLabel.attributedText {//textLabel.text ?? ""
//            mutable = NSMutableAttributedString(attributedString: attri)
//        }
//
//        let strAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
//                       NSAttributedString.Key.foregroundColor: textColor]
//
//        mutable.addAttributes(strAttr, range: NSRangeFromString(text))
        
        textLabel.attributedText = attributedText
        
        textLabel.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: bounds.size.width, height: textLabel.frame.maxY+10)
    }
    
    @objc private func clickBackBtn(){
        UIView.animate(withDuration: 0.30) {[weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
            logView = nil
        }
    }
    
    @objc private func clickSizeBtn(){
        if heightConstraint.constant == half_height {
            heightConstraint.constant=UIScreen.main.bounds.height-40
        }else {
            heightConstraint.constant=half_height
        }
    }
    
    @objc private func clickBottomBtn(){
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height-scrollView.bounds.height+scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @objc private func clickLeftBtn(){
        
    }
    
    @objc private func clickRightBtn(){
        
    }
}

extension WisdomHUDLogView {
    
    class func setLog(isOpen: Bool) {
        WisdomHUDLogView.isOpen = isOpen
    }
    
    static func setPrint(text: String, textColor: UIColor) {
        if WisdomHUDLogView.isOpen {
            if Thread.isMainThread {
                setLog()
            }else {
                DispatchQueue.main.async { setLog() }
            }
            func setLog(){
    #if DEBUG
                if let cur_logView = logView, cur_logView.superview==nil {
                    logView = nil
                }
                if logView == nil, let screen = WisdomHUD.getScreenWindow() {
                    let vi = WisdomHUDLogView()
                    screen.addSubview(vi)
                    
                    let width: CGFloat = UIScreen.main.bounds.width > vi.maxWidth ? vi.maxWidth:UIScreen.main.bounds.width
                    screen.addConstraint(NSLayoutConstraint(item: vi,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1.0,
                                                            constant: width))
                    screen.addConstraint(NSLayoutConstraint(item: vi,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: screen,
                                                            attribute: .top,
                                                            multiplier: 1.0,
                                                            constant: 20))
                    screen.addConstraint(NSLayoutConstraint(item: vi,
                                                            attribute: .left,
                                                            relatedBy: .equal,
                                                            toItem: screen,
                                                            attribute: .left,
                                                            multiplier: 1.0,
                                                            constant: 0))
                    screen.addConstraint(vi.heightConstraint)
                    logView = vi
                }
    #endif
                if logView == nil {
                    print(text)
                }else {
                    logView?.setText(text: text, textColor: textColor)
                }
            }
        }
    }
}
