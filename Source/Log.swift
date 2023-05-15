//
//  Log.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/17.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

private var logView: WisdomHUDLogView?

final class WisdomHUDLogView: UIView {
    
    static var isOpen = false
    
    private let itemWidth: CGFloat = 24.0
    private lazy var maxSize = CGSize(width: 414.0, height: 896.0-itemWidth)
    private lazy var hangHeight: CGFloat = itemWidth+1
    private lazy var hang_Btn_Width = hangHeight*3.5
    
    private func getHeight(baseHeight: CGFloat)->CGFloat{
        return baseHeight>maxSize.height ? maxSize.height:baseHeight
    }
    
    private func getWidth()->CGFloat{
        return UIScreen.main.bounds.width>maxSize.width ? maxSize.width:UIScreen.main.bounds.width
    }
    
    let coverView = UIView()
    let scrollView = UIScrollView()
    let textLabel = UILabel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "【Initialize: last on top】"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var closeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        button.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
        button.layer.borderWidth=1
        
        let path = UIBezierPath()
        let spacing = itemWidth/3.8
        path.move(to: CGPoint(x: spacing, y: spacing))
        path.addLine(to: CGPoint(x: itemWidth-spacing, y: itemWidth-spacing))
        path.move(to: CGPoint(x: spacing, y: itemWidth-spacing))
        path.addLine(to: CGPoint(x: itemWidth-spacing, y: spacing))

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
        button.backgroundColor = closeBtn.backgroundColor
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
        button.backgroundColor = closeBtn.backgroundColor
        button.titleLabel?.font = sizeBtn.titleLabel?.font
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
        button.backgroundColor = closeBtn.backgroundColor
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
        button.backgroundColor = closeBtn.backgroundColor
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
        button.backgroundColor = closeBtn.backgroundColor
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
        button.backgroundColor = closeBtn.backgroundColor
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
    
    private lazy var underBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = closeBtn.backgroundColor
        button.addTarget(self, action: #selector(clickUnderBtn), for: .touchUpInside)
        button.layer.masksToBounds=true
        button.layer.cornerRadius=5
        button.layer.borderColor=UIColor.white.cgColor
        button.layer.borderWidth=1

        let path = UIBezierPath()
        path.move(to: CGPoint(x: itemWidth/5, y: itemWidth/2))
        path.addLine(to: CGPoint(x: itemWidth/2, y: itemWidth/5*4))
        path.move(to: CGPoint(x: itemWidth/2, y: itemWidth/5*4))
        path.addLine(to: CGPoint(x: itemWidth/5*4, y: itemWidth/2))
        
        path.move(to: CGPoint(x: itemWidth/2, y: itemWidth/4))
        path.addLine(to: CGPoint(x: itemWidth/2, y: itemWidth/5*4))

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
        button.setTitle("WisdomHUD", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
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
                                            constant: getHeight(baseHeight: (UIScreen.main.bounds.height-30)/2))
        return constraint
    }()
    
    private(set) lazy var widthConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: getWidth())
        return constraint
    }()
    
    private var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.85)
        translatesAutoresizingMaskIntoConstraints = false
        coverView.translatesAutoresizingMaskIntoConstraints = false
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
        underBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coverView)
        addSubview(scrollView)
        addSubview(closeBtn)
        addSubview(sizeBtn)
        addSubview(bgColorBtn)
        addSubview(bottomBtn)
        addSubview(topBtn)
        addSubview(rightBtn)
        addSubview(underBtn)
        addSubview(leftBtn)
        addSubview(hangBtn)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textLabel)
        
        wisdom_addConstraint(with: coverView,
                             topView: self,
                             leftView: self,
                             bottomView: self,
                             rightView: self,
                             edgeInset: .zero)

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
                             edgeInset: UIEdgeInsets(top: 25, left: 8, bottom: 0, right: -8))
        
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
        
        wisdom_addConstraint(with: underBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: rightBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        underBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: leftBtn,
                             topView: nil,
                             leftView: nil,
                             bottomView: closeBtn,
                             rightView: underBtn,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -itemWidth-20))
        
        leftBtn.wisdom_addConstraint(width: itemWidth, height: itemWidth)
        
        wisdom_addConstraint(with: hangBtn,
                             topView: self,
                             leftView: self,
                             bottomView: nil,
                             rightView: nil,
                             edgeInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        hangBtn.wisdom_addConstraint(width: hang_Btn_Width, height: hangHeight)
        hangBtn.isHidden=true
        
        coverView.layer.shadowColor = UIColor(white: 0, alpha: 0.6).cgColor
        coverView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        coverView.layer.shadowOpacity = 1
        coverView.backgroundColor = .clear
        coverView.isHidden=true
        
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
    
    func setText(text: String) {
        textLabel.text = text+"\n"+(textLabel.text ?? "")
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
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
        let than:CGFloat = btn.isSelected ? 1.0:0.5
        heightConstraint.constant = getHeight(baseHeight: (UIScreen.main.bounds.height-30)*than)
        updateContent()
    }
    
    @objc private func clickBgColorBtn(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        backgroundColor = UIColor(white: 0, alpha: !btn.isSelected ? 0.85:0.45)
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
        coverView.isHidden=false
        shapeLayer?.removeFromSuperlayer()
        transform=CGAffineTransform(translationX: 0, y: hangHeight*5)
        hangBtn.transform=CGAffineTransform(translationX: -(hang_Btn_Width/2-hangHeight/2), y: hang_Btn_Width/2-hangHeight/2)
        hangBtn.transform=hangBtn.transform.rotated(by: -Double.pi*0.5)
        
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.widthConstraint.constant = self?.hangHeight ?? 0
            self?.heightConstraint.constant = self?.hang_Btn_Width ?? 0
        })
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: hangHeight, y: hang_Btn_Width*0.1))
        path.addLine(to: CGPoint(x: hangHeight, y: hang_Btn_Width*0.85))
        path.addLine(to: CGPoint(x: 0, y: hang_Btn_Width))
        path.addLine(to: CGPoint(x: 0, y: 0))

        let shapeLayer = CAShapeLayer()
        self.shapeLayer=shapeLayer
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0.8).cgColor
        shapeLayer.strokeColor = UIColor.wisdom_color(hex: "F5F5F5").cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 1.2
        shapeLayer.strokeEnd = 1.0
        shapeLayer.path = path.cgPath
        coverView.layer.addSublayer(shapeLayer)
    }
    
    @objc private func clickRightBtn(){
        for item in subviews {
            item.isHidden=true
        }
        backgroundColor = .clear
        hangBtn.isHidden=false
        coverView.isHidden=false
        shapeLayer?.removeFromSuperlayer()
        transform=CGAffineTransform(translationX: getWidth()-hangHeight, y: hangHeight*5)
        hangBtn.transform=CGAffineTransform(translationX: -(hang_Btn_Width/2-hangHeight/2), y: hang_Btn_Width/2-hangHeight/2)
        hangBtn.transform=hangBtn.transform.rotated(by: -Double.pi*0.5)
        
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.widthConstraint.constant = self?.hangHeight ?? 0
            self?.heightConstraint.constant = self?.hang_Btn_Width ?? 0
        })
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 1, y: hang_Btn_Width*0.1))
        path.addLine(to: CGPoint(x: hangHeight, y: 0))
        path.addLine(to: CGPoint(x: hangHeight, y: hang_Btn_Width))
        path.addLine(to: CGPoint(x: 1, y: hang_Btn_Width*0.85))
        path.addLine(to: CGPoint(x: 1, y: hang_Btn_Width*0.1))

        let shapeLayer = CAShapeLayer()
        self.shapeLayer=shapeLayer
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0.8).cgColor
        shapeLayer.strokeColor = UIColor.wisdom_color(hex: "F5F5F5").cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 1.2
        shapeLayer.strokeEnd = 1.0
        shapeLayer.path = path.cgPath
        coverView.layer.addSublayer(shapeLayer)
    }
    
    @objc private func clickUnderBtn(){
        for item in subviews {
            item.isHidden=true
        }
        backgroundColor = .clear
        hangBtn.isHidden=false
        coverView.isHidden=false
        shapeLayer?.removeFromSuperlayer()
        transform=CGAffineTransform(translationX: hangHeight*2, y: UIScreen.main.bounds.height-20-hangHeight)
        
        UIView.animate(withDuration: 0.30, animations: { [weak self] in
            self?.widthConstraint.constant = self?.hang_Btn_Width ?? 0
            self?.heightConstraint.constant = self?.hangHeight ?? 0
        })
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: hangHeight))
        path.addLine(to: CGPoint(x: hang_Btn_Width*0.1, y: 0))
        path.addLine(to: CGPoint(x: hang_Btn_Width*0.9, y: 0))
        path.addLine(to: CGPoint(x: hang_Btn_Width, y: hangHeight))
        path.addLine(to: CGPoint(x: 0, y: hangHeight))

        let shapeLayer = CAShapeLayer()
        self.shapeLayer=shapeLayer
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0.8).cgColor
        shapeLayer.strokeColor = UIColor.wisdom_color(hex: "F5F5F5").cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 1.2
        shapeLayer.strokeEnd = 1.0
        shapeLayer.path = path.cgPath
        coverView.layer.addSublayer(shapeLayer)
    }
    
    @objc private func clickHangBtn(){
        for item in subviews {
            item.isHidden=false
        }
        backgroundColor = UIColor(white: 0, alpha: !bgColorBtn.isSelected ? 0.85:0.45)
        hangBtn.transform = .identity
        hangBtn.isHidden=true
        coverView.isHidden=true
        shapeLayer?.removeFromSuperlayer()
        transform=CGAffineTransform.identity
        UIView.animate(withDuration: 0.30, animations: {
            updateConstraint()
        }, completion: { [weak self] _ in
            self?.updateContent()
        })
        
        func updateConstraint(){
            let than:CGFloat = sizeBtn.isSelected ? 1.0:2.0
            heightConstraint.constant = getHeight(baseHeight: (UIScreen.main.bounds.height-30)/than)
            widthConstraint.constant = getWidth()
        }
    }
}

extension WisdomHUDLogView {
    
    class func openLog() {
        WisdomHUDLogView.isOpen = true
    }
    
    static func setLog(text: String){
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
                    logView?.setText(text: text)
                }
            }
#endif
        }
    }
}
