//
//  WisdomHUDImage.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit


@objc public final class WisdomHUDSuccessView: UIView {
    
    @objc public static func getLineWidth()->CGFloat{
        return 1.2
    }
    
    @objc public static func getAnimDuration()->CGFloat{
        return 0.8
    }
    
    @objc public static func getLightColor()->CGColor{
        return UIColor(white: 0.1, alpha: 1).cgColor
    }
    
    @objc public let size: CGFloat
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                    radius: (size - Self.getLineWidth())/2,
                    startAngle: Double.pi*1.5,
                      endAngle: Double.pi*3.5,
                     clockwise: true)
        
        path.move(to: CGPoint(x: size/3.9, y: size/2))
        path.addLine(to: CGPoint(x: size/5*2.2, y: size/3*2))
        path.addLine(to: CGPoint(x: size*0.74, y: size/2.7))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = Self.getLineWidth()
        circle.strokeEnd = 1.0 // 视图具体的位置
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = Self.getAnimDuration()
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)// 保持匀速
        return anim
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch barStyle {
        case .dark:
            circleLayer.strokeColor = UIColor.white.cgColor
        case .light:
            circleLayer.strokeColor = Self.getLightColor()
        //case .skyBlue:
        //    circleLayer.strokeColor = UIColor.white.cgColor
        case .hide:
            circleLayer.strokeColor = UIColor.white.cgColor
        }
        
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func beginAnimation(isRepeat: Bool){
        animation.repeatCount = isRepeat ? MAXFLOAT : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}


@objc public final class WisdomHUDErrorView: UIView {
    
    @objc public let size: CGFloat
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                        radius: (size - WisdomHUDSuccessView.getLineWidth())/2,
                    startAngle: Double.pi*1.5,
                      endAngle: Double.pi*3.5,
                     clockwise: true)
        
        path.move(to: CGPoint(x: size/3, y: size/3))
        path.addLine(to: CGPoint(x: size/3*2, y: size/3*2))
        path.move(to: CGPoint(x: size/3, y: size/3*2))
        path.addLine(to: CGPoint(x: size/3*2, y: size/3))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = WisdomHUDSuccessView.getLineWidth()
        circle.strokeEnd = 1.0 // 视图具体的位置
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = WisdomHUDSuccessView.getAnimDuration()
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)// 保持匀速
        return anim
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch barStyle {
        case .dark:
            circleLayer.strokeColor = UIColor.white.cgColor
        case .light:
            circleLayer.strokeColor = WisdomHUDSuccessView.getLightColor()
        //case .skyBlue:
        //    circleLayer.strokeColor = UIColor.white.cgColor
        case .hide:
            circleLayer.strokeColor = UIColor.white.cgColor
        }
        
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func beginAnimation(isRepeat: Bool){
        animation.repeatCount = isRepeat ? MAXFLOAT : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}


@objc public final class WisdomHUDWarningView: UIView {
    
    @objc public let size: CGFloat
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                        radius: (size - WisdomHUDSuccessView.getLineWidth())/2,
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
        circle.lineWidth = WisdomHUDSuccessView.getLineWidth()
        circle.strokeEnd = 1.0 // 视图具体的位置
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = WisdomHUDSuccessView.getAnimDuration()
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)// 保持匀速
        return anim
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch barStyle {
        case .dark:
            circleLayer.strokeColor = UIColor.white.cgColor
        case .light:
            circleLayer.strokeColor = WisdomHUDSuccessView.getLightColor()
        //case .skyBlue:
        //    circleLayer.strokeColor = UIColor.white.cgColor
        case .hide:
            circleLayer.strokeColor = UIColor.white.cgColor
        }
        
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func beginAnimation(isRepeat: Bool){
        animation.repeatCount = isRepeat ? MAXFLOAT : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}
