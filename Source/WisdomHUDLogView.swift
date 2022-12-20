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
    private let maxHeight: CGFloat = 896.0-40.0
    private let hangWidth: CGFloat = 20
    private lazy var half_height = UIScreen.main.bounds.height*0.5>maxHeight ? maxHeight:UIScreen.main.bounds.height*0.5
    
    let scrollView = UIScrollView()
    let textLabel = UILabel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "【Initialize】"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
        button.layer.borderWidth=1
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: itemWidth/3, y: itemWidth/3))
        path.addLine(to: CGPoint(x: itemWidth/3*2, y: itemWidth/3*2))
        path.move(to: CGPoint(x: itemWidth/3, y: itemWidth/3*2))
        path.addLine(to: CGPoint(x: itemWidth/3*2, y: itemWidth/3))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private lazy var sizeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setTitle("size", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(clickSizeBtn(btn:)), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
        button.layer.borderWidth=1
        return button
    }()
    
    private lazy var bgColorBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setTitle("bgc", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(clickBgColorBtn(btn:)), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
        button.layer.borderWidth=1
        return button
    }()
    
    private lazy var bottomBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickBottomBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
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
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private lazy var topBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickTopBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
        button.layer.borderWidth=1
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: itemWidth/5, y: itemWidth/2))
        path.addLine(to: CGPoint(x: itemWidth/2, y: itemWidth/5))
        path.move(to: CGPoint(x: itemWidth/2, y: itemWidth/5))
        path.addLine(to: CGPoint(x: itemWidth/5*4, y: itemWidth/2))
        
        path.move(to: CGPoint(x: itemWidth/3*1.1, y: itemWidth/3))
        path.addLine(to: CGPoint(x: itemWidth/3*1.1, y: itemWidth/4*3))
        path.move(to: CGPoint(x: itemWidth/3*2*0.94, y: itemWidth/3))
        path.addLine(to: CGPoint(x: itemWidth/3*2*0.94, y: itemWidth/4*3))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private lazy var leftBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickLeftBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
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
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private lazy var rightBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
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
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 1.0
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        button.layer.addSublayer(circle)
        return button
    }()
    
    private lazy var hangBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(clickHangBtn), for: .touchUpInside)
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
    
    private(set) lazy var widthConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: UIScreen.main.bounds.width>maxWidth ? maxWidth:UIScreen.main.bounds.width)
        return constraint
    }()
    
    private var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        sizeBtn.translatesAutoresizingMaskIntoConstraints = false
        bgColorBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomBtn.translatesAutoresizingMaskIntoConstraints = false
        topBtn.translatesAutoresizingMaskIntoConstraints = false
        leftBtn.translatesAutoresizingMaskIntoConstraints = false
        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        hangBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        addSubview(closeBtn)
        addSubview(sizeBtn)
        addSubview(bgColorBtn)
        addSubview(bottomBtn)
        addSubview(topBtn)
        addSubview(rightBtn)
        addSubview(leftBtn)
        addSubview(hangBtn)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textLabel)

        wisdom_addConstraint(with: scrollView,
                             topView: self,
                             leftView: self,
                             bottomView: self,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 10, left: 0, bottom: -itemWidth-15, right: 0))

        wisdom_addConstraint(with: titleLabel,
                             topView: scrollView,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
        
        wisdom_addConstraint(with: textLabel,
                             topView: titleLabel,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 25, left: 10, bottom: 0, right: -8))
        
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
        
        wisdom_addConstraint(with: bgColorBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: sizeBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        bgColorBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: bottomBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: bgColorBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        bottomBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: topBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: bottomBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        topBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: rightBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: topBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        rightBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: leftBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: rightBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        leftBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: hangBtn,
                             topView: self,
                             leftView: self,
                             bottomView: nil,
                             rightView: nil,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        hangBtn.wisdom_addConstraint(width: hangWidth, height: hangWidth*3)
        hangBtn.isHidden=true
        hangBtn.layer.shadowColor = UIColor(white: 0, alpha: 0.6).cgColor
        hangBtn.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        hangBtn.layer.shadowOpacity = 1
        
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textLabel.textAlignment = .left

        updateContent()
    }
    
    private func updateContent(){
        textLabel.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: bounds.size.width, height: textLabel.frame.maxY+10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String, textColor: UIColor) {
        textLabel.text = text+"\n"+(textLabel.text ?? "")
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular),
                          NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.paragraphStyle: style]
        
        let attributedText = NSAttributedString(string: textLabel.text ?? "", attributes: attributes)
        textLabel.attributedText = attributedText
        
        updateContent()
    }
    
    @objc private func clickBackBtn(){
        UIView.animate(withDuration: 0.30) {[weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
            logView = nil
        }
    }
    
    @objc private func clickSizeBtn(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        heightConstraint.constant = btn.isSelected ? maxHeight:half_height
        updateContent()
    }
    
    @objc private func clickBgColorBtn(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        backgroundColor = UIColor(white: 0, alpha: btn.isSelected ? 0.85:0.4)
    }
    
    @objc private func clickBottomBtn(){
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height-scrollView.bounds.size.height+scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @objc private func clickTopBtn(){
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc private func clickLeftBtn(){
        for item in subviews {
            item.isHidden=true
        }
        backgroundColor = .clear
        hangBtn.isHidden=false
        shapeLayer?.removeFromSuperlayer()
        transform=CGAffineTransform(translationX: 0, y: hangWidth*5)
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.widthConstraint.constant = self?.hangWidth ?? 0
            self?.heightConstraint.constant = (self?.hangWidth ?? 0)*3
        })
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: hangWidth-1, y: hangWidth/3))
        path.addLine(to: CGPoint(x: hangWidth-1, y: itemWidth*2.5))
        path.addLine(to: CGPoint(x: 0, y: itemWidth*3))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shapeLayer = CAShapeLayer()
        self.shapeLayer=shapeLayer
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0.8).cgColor
        shapeLayer.strokeColor = UIColor.wisdom_colorHex(hex: "F5F5F5").cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 1.2
        shapeLayer.strokeEnd = 1.0
        shapeLayer.path = path.cgPath
        hangBtn.layer.addSublayer(shapeLayer)
    }
    
    @objc private func clickRightBtn(){
        for item in subviews {
            item.isHidden=true
        }
        backgroundColor = .clear
        hangBtn.isHidden=false
        shapeLayer?.removeFromSuperlayer()
        let width = UIScreen.main.bounds.width>maxWidth ? maxWidth:UIScreen.main.bounds.width
        transform=CGAffineTransform(translationX: width-hangWidth, y: hangWidth*5)
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.widthConstraint.constant = self?.hangWidth ?? 0
            self?.heightConstraint.constant = (self?.hangWidth ?? 0)*3
        })
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 1, y: hangWidth/3))
        path.addLine(to: CGPoint(x: hangWidth, y: 0))
        path.addLine(to: CGPoint(x: hangWidth, y: itemWidth*3))
        path.addLine(to: CGPoint(x: 1, y: itemWidth*2.7))
        path.addLine(to: CGPoint(x: 1, y: hangWidth/3))

        let shapeLayer = CAShapeLayer()
        self.shapeLayer=shapeLayer
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0.8).cgColor
        shapeLayer.strokeColor = UIColor.wisdom_colorHex(hex: "F5F5F5").cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 1.2
        shapeLayer.strokeEnd = 1.0
        shapeLayer.path = path.cgPath
        hangBtn.layer.addSublayer(shapeLayer)
    }
    
    @objc private func clickHangBtn(){
        for item in subviews {
            item.isHidden=false
        }
        backgroundColor = UIColor(white: 0, alpha: bgColorBtn.isSelected ? 0.85:0.4)
        hangBtn.isHidden=true
        transform=CGAffineTransform.identity
        UIView.animate(withDuration: 0.30, animations: {
            updateConstraint()
        }, completion: { [weak self] _ in
            self?.updateContent()
        })
        
        func updateConstraint(){
            widthConstraint.constant = UIScreen.main.bounds.width>maxWidth ? maxWidth:UIScreen.main.bounds.width
            heightConstraint.constant = sizeBtn.isSelected ? maxHeight:half_height
        }
    }
}

extension WisdomHUDLogView {
    
    class func setLog(isOpen: Bool) {
        WisdomHUDLogView.isOpen = isOpen
    }
    
    static func setPrint(text: String, textColor: UIColor){
        if WisdomHUDLogView.isOpen {
#if DEBUG
            if Thread.isMainThread {
                setLog()
            }else {
                DispatchQueue.main.async { setLog() }
            }
            func setLog(){
                if let cur_logView = logView, cur_logView.superview==nil {
                    logView = nil
                }
                if logView == nil, let screen = WisdomHUD.getScreenWindow() {
                    let vi = WisdomHUDLogView()
                    screen.addSubview(vi)
                    screen.addConstraint(vi.widthConstraint)
                    screen.addConstraint(vi.heightConstraint)
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
                    logView = vi
                }

                if logView == nil {
                    print(text)
                }else {
                    logView?.setText(text: text, textColor: textColor)
                }
            }
#endif
        }
    }
}
