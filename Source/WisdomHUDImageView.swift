//
//  WisdomHUDImageView.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit


final class WisdomHUDImageView: UIView {
    
    private var imageView: WisdomHUDImageBaseView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomHUDImageView: WisdomHUDSetImageable {
    
    func setLoadingImage(size: CGFloat, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle) {
        imageView?.removeFromSuperview()
        imageView = nil
        
        switch loadingStyle {
        case .system:
            imageView = WisdomHUDIndicatorView(size: size, barStyle: barStyle)
        case .rotate:
            imageView = WisdomHUDRotateView(size: size, barStyle: barStyle)
        case .progressArc:
            imageView = WisdomHUDProgressArcView(size: size, barStyle: barStyle)
        case .tadpoleArc:
            imageView = WisdomHUDTadpoleArcView(size: size, barStyle: barStyle)
        case .chaseBall:
            imageView = WisdomHUDChaseBallView(size: size, barStyle: barStyle)
        case .pulseBall:
            imageView = WisdomHUDPulseBallView(size: size, barStyle: barStyle)
        case .pulseShape:
            imageView = WisdomHUDPulseShapeView(size: size, barStyle: barStyle)
        default: break
        }
        
        if let itemVi = imageView {
            addSubview(itemVi)
            
            if loadingStyle == .system {
                wisdom_addConstraint(toCenterX: itemVi, toCenterY: itemVi)
            }else {
                wisdom_addConstraint(with: itemVi,
                                  topView: self,
                                 leftView: self,
                               bottomView: self,
                                rightView: self,
                                edgeInset: UIEdgeInsets.zero)
            }
        }
    }
    
    func setSuccessImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        imageView?.removeFromSuperview()
        imageView = WisdomHUDSuccessView(size: size, barStyle: barStyle)
        addSubview(imageView!)
        
        wisdom_addConstraint(with: imageView!,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        imageView?.beginAnimation(isRepeat: false)
    }
    
    func setErrorImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        imageView?.removeFromSuperview()
        imageView = WisdomHUDErrorView(size: size, barStyle: barStyle)
        addSubview(imageView!)
        
        wisdom_addConstraint(with: imageView!,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        imageView?.beginAnimation(isRepeat: false)
    }
    
    func setWarningImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        imageView?.removeFromSuperview()
        imageView = WisdomHUDWarningView(size: size, barStyle: barStyle)
        addSubview(imageView!)
        
        wisdom_addConstraint(with: imageView!,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        imageView?.beginAnimation(isRepeat: false)
    }
    
    func setDismissImage() {
        imageView?.endDismiss()
    }
}


public class WisdomHUDImageBaseView: UIView {
    
    @objc public let size: CGFloat
    
    @objc public init(size: CGFloat) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomHUDImageBaseView {
    
    @objc public func getLineWidth()->CGFloat{
        return 1.2
    }
    
    @objc public class func getAnimDuration()->CGFloat{
        return 0.8
    }
    
    @objc public class func getLightColor()->CGColor{
        return UIColor.black.cgColor
    }
    
    @objc public func beginAnimation(isRepeat: Bool){
        
    }
    
    @objc public func endDismiss(){
        
    }
}


@objc public final class WisdomHUDSuccessView: WisdomHUDImageBaseView {
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                        radius: (size - getLineWidth())/2,
                    startAngle: Double.pi*1.25,
                      endAngle: Double.pi*3.25,
                     clockwise: true)
        
        path.move(to: CGPoint(x: size/3.9, y: size/2))
        path.addLine(to: CGPoint(x: size/5*2.2, y: size/3*2))
        path.addLine(to: CGPoint(x: size*0.74, y: size/2.7))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = getLineWidth()
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = Self.getAnimDuration()
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        return anim
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            circleLayer.strokeColor = UIColor.white.cgColor
        case .light:
            circleLayer.strokeColor = Self.getLightColor()
        case .hide:
            circleLayer.strokeColor = UIColor.white.cgColor
        }
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public override func getLineWidth()->CGFloat{
        return size/24//29-1.2
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return 0.8
    }
    
    @objc public override class func getLightColor()->CGColor{
        return UIColor.black.cgColor
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        animation.repeatCount = isRepeat ? MAXFLOAT : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}


@objc public final class WisdomHUDErrorView: WisdomHUDImageBaseView {
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                        radius: (size - getLineWidth())/2,
                    startAngle: Double.pi*1.25,
                      endAngle: Double.pi*3.25,
                     clockwise: true)
        
        path.move(to: CGPoint(x: size/3, y: size/3))
        path.addLine(to: CGPoint(x: size/3*2, y: size/3*2))
        path.move(to: CGPoint(x: size/3, y: size/3*2))
        path.addLine(to: CGPoint(x: size/3*2, y: size/3))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = getLineWidth()
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = Self.getAnimDuration()
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        return anim
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            circleLayer.strokeColor = UIColor.white.cgColor
        case .light:
            circleLayer.strokeColor = Self.getLightColor()
        case .hide:
            circleLayer.strokeColor = UIColor.white.cgColor
        }
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public override func getLineWidth()->CGFloat{
        return size/24//29-1.2
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return WisdomHUDSuccessView.getAnimDuration()
    }
    
    @objc public override class func getLightColor()->CGColor{
        return WisdomHUDSuccessView.getLightColor()
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        animation.repeatCount = isRepeat ? MAXFLOAT : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}


@objc public final class WisdomHUDWarningView: WisdomHUDImageBaseView {
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                        radius: (size - getLineWidth())/2,
                    startAngle: Double.pi*1.5,
                      endAngle: Double.pi*3.5,
                     clockwise: true)
        
        path.move(to: CGPoint(x: size/2-0.4, y: size/4))
        path.addLine(to: CGPoint(x: size/2, y: size/3*1.7))
        
        path.move(to: CGPoint(x: size/2+0.4, y: size/4))
        path.addLine(to: CGPoint(x: size/2, y: size/3*1.7))

        path.move(to: CGPoint(x: size/2, y: size/3*2.1+size/30.0))
        path.addArc(withCenter: CGPoint(x: size/2, y: size/3*2.1+size/30.0),
                        radius: size/30.0,
                    startAngle: 0,
                      endAngle: Double.pi*2,
                     clockwise: true)

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = getLineWidth()
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = Self.getAnimDuration()
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        return anim
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            circleLayer.strokeColor = UIColor.white.cgColor
        case .light:
            circleLayer.strokeColor = Self.getLightColor()
        case .hide:
            circleLayer.strokeColor = UIColor.white.cgColor
        }
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public override func getLineWidth()->CGFloat{
        return size/24//29-1.2
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return WisdomHUDSuccessView.getAnimDuration()
    }
    
    @objc public override class func getLightColor()->CGColor{
        return WisdomHUDSuccessView.getLightColor()
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        animation.repeatCount = isRepeat ? MAXFLOAT : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}
