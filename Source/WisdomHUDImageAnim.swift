//
//  WisdomHUDImageAnim.swift
//  WisdomHUDDemo
//
//  Created by jianfeng tang on 2022/10/15.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit


// MARK: HUD IndicatorView: WisdomLoadingStyle.system
@objc public final class WisdomHUDIndicatorView: UIActivityIndicatorView {
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        var style: UIActivityIndicatorView.Style = .white
        if barStyle != .dark {
            style = .gray
        }
        super.init(style: style)
        translatesAutoresizingMaskIntoConstraints = false
        transform = CGAffineTransform.init(scaleX: size/20.0, y: size/20.0)
        startAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: HUD RotateView: WisdomLoadingStyle.rotate
@objc public final class WisdomHUDRotateView: UIView {
    
    @objc public private(set) lazy var lineWidth: CGFloat = size/14.0
    
    @objc public let size: CGFloat
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                   radius: size/2.0-lineWidth,
                               startAngle: Double.pi*1.5,
                                 endAngle: Double.pi*1.22,
                                clockwise: true)

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = lineWidth
        circle.strokeEnd = 1.0 // 视图具体的位置
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        // 画圆形，就是靠 `strokeEnd`
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = 0.6
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)// 保持匀速
        anim.delegate = self
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
        
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setRotationAnim() {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi*2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 1
        rotationAnim.isRemovedOnCompletion = false
        layer.add(rotationAnim, forKey: nil)
    }
}

extension WisdomHUDRotateView: CAAnimationDelegate {
    
    @objc public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        setRotationAnim()
    }
}


// MARK: HUD ProgressArcView: WisdomLoadingStyle.progressArc
@objc public final class WisdomHUDProgressArcView: UIView {
    
    @objc public private(set) lazy var lineWidth: CGFloat = size/14.0
    
    @objc public let size: CGFloat
    
    @objc public private(set) var lineColor: UIColor = UIColor.white
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        t.schedule(deadline: .now(), repeating: .milliseconds(50))
        t.setEventHandler(handler: { [weak self] in
            self?.setRotationAnim()
        })
        return t
    }()

    private lazy var originStart = { return origin }() //开始位置

    private lazy var originEnd = { return origin+distance }() //结束位置
    
    @objc public let origin = Double.pi*1.5
    
    @objc public let distance = Double.pi/10.5
    
    @objc public let maxOrigin = Double.pi*3.5
    
    private var animStart = false
    
    private lazy var circleLayer: CAShapeLayer = {
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.white.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = lineWidth
        circle.strokeEnd = 1.0 // 视图具体的位置
        return circle
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch barStyle {
        case .dark:
            lineColor = UIColor.white
        case .light:
            lineColor = UIColor.black// = WisdomHUDSuccessView.getLightColor()
        //case .skyBlue:
        //    circleLayer.strokeColor = UIColor.white.cgColor
        case .hide:
            lineColor = UIColor.white
        }
        
        layer.addSublayer(circleLayer)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                   radius: size/2.0-lineWidth,
                               startAngle: origin,
                                 endAngle: maxOrigin,
                                clockwise: true)

        circleLayer.path = path.cgPath
        
        timer.resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setRotationAnim() {
        if !animStart {
            if originEnd+distance < maxOrigin {
                originEnd = originEnd+distance
            }else if originEnd+distance >= maxOrigin {
                originEnd = origin//+(originEnd+distance-maxOrigin)
                originStart = originEnd+distance
                animStart = true
            }
        } else {
            if originStart+distance < maxOrigin {
                originStart = originStart+distance
            }else if originStart+distance >= maxOrigin {
                originStart = origin//+(originStart+distance-maxOrigin)
                originEnd = originStart+distance
                animStart = false
            }
        }
        let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                   radius: size/2.0-lineWidth,
                               startAngle: originStart,
                                 endAngle: originEnd,
                                clockwise: true)
        DispatchQueue.main.async { [weak self] in
            self?.circleLayer.path = path.cgPath
        }
    }
}


// MARK: HUD TadpoleArcView: WisdomLoadingStyle.tadpoleArc
@objc public final class WisdomHUDTadpoleArcView: UIView {
    
    @objc public let size: CGFloat
    
    @objc public private(set) var fillColor: UIColor = UIColor.white
    
    @objc public private(set) var strokeColor: UIColor = UIColor.white

    private lazy var distance = { return size/10.0 }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.size = size+0.5
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch barStyle {
        case .dark:
            fillColor = UIColor.white
            strokeColor = UIColor.darkGray
        case .light:
            fillColor = UIColor.black
            strokeColor = UIColor.lightGray
        //case .skyBlue:
        //    circleLayer.strokeColor = UIColor.white.cgColor
        case .hide:
            fillColor = UIColor.white
            strokeColor = UIColor.darkGray
        }
        
        //let imageView = UIImageView(image: UIImage(named: "TadpoleArc"))
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        //addSubview(imageView)
        //wisdom_addConstraint(with: imageView,
        //                  topView: self,
        //                 leftView: self,
        //               bottomView: self,
        //                rightView: self,
        //                edgeInset: UIEdgeInsets.zero)
    
        let right_layerView = getLayerView()
        let bottom_layerView = getLayerView()
        let left_layerView = getLayerView()
        
        addSubview(right_layerView)
        addSubview(bottom_layerView)
        addSubview(left_layerView)
        
        wisdom_addConstraint(with: right_layerView,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
    
        wisdom_addConstraint(with: bottom_layerView,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        wisdom_addConstraint(with: left_layerView,
                          topView: self,
                         leftView: self,
                       bottomView: self,
                        rightView: self,
                        edgeInset: UIEdgeInsets.zero)
        
        bottom_layerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*120)
        left_layerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*240)
        
        setRotationAnim()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLayerView() -> UIView {
        let topPoint = CGPoint(x: size/2+distance, y: distance/1.7)
        let inoutPoint = CGPoint(x: size-distance/2.5, y: (size-distance*2)/3*2.2+distance)
        let insidePoint = CGPoint(x: inoutPoint.x-distance*0.7, y: (size-distance*2)/3*2.1+distance)
        
        let path = UIBezierPath()
        path.move(to: topPoint)
        path.addQuadCurve(to: inoutPoint, controlPoint: CGPoint(x: size+distance*0.6, y: size/4.8))
        
        let width = inoutPoint.x-insidePoint.x
        let height = inoutPoint.y-insidePoint.y
        path.addArc(withCenter: CGPoint(x: insidePoint.x+width/2, y: insidePoint.y+height/2),
                        radius: sqrt(width*width+height*height)/2,
                    startAngle: Double.pi*2.2,
                      endAngle: Double.pi*1.2,
                     clockwise: true)

        path.addQuadCurve(to: topPoint, controlPoint: CGPoint(x: size+distance*0.2, y: size/4.6))

        let circle = CAShapeLayer()
        circle.fillColor = fillColor.cgColor
        circle.strokeColor = strokeColor.cgColor//UIColor.blue.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 0.3
        circle.strokeEnd = 1.0 // 视图具体的位置
        circle.path = path.cgPath
        
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = UIColor.clear
        vi.layer.addSublayer(circle)
        return vi
    }
    
    private func setRotationAnim() {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi*2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 1.20
        rotationAnim.isRemovedOnCompletion = false
        layer.add(rotationAnim, forKey: nil)
    }
}


// MARK: HUD ChaseBallView: WisdomLoadingStyle.chaseBall
@objc public final class WisdomHUDChaseBallView: UIView {
    
    @objc public let size: CGFloat
    
    @objc public private(set) var ballColor: UIColor = UIColor.white
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch barStyle {
        case .dark:
            ballColor = UIColor.white
        case .light:
            ballColor = UIColor.black
        //case .skyBlue:
        //    circleLayer.strokeColor = UIColor.white.cgColor
        case .hide:
            ballColor = UIColor.white
        }
        
        let circleSize = self.size/5.5

        // Draw circles
        for i in 0 ..< 5 {
            let factor = Float(i)*1/5
            let path: UIBezierPath = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: circleSize/2.0, y: circleSize/2.0),
                            radius: circleSize/2-0.3,
                        startAngle: 0,
                          endAngle: Double.pi*2,
                         clockwise: false)
            
            let circle = CAShapeLayer()
            circle.fillColor = ballColor.cgColor
            circle.strokeColor = ballColor.cgColor
            circle.lineCap = CAShapeLayerLineCap.round
            circle.strokeEnd = 1.0 // 视图具体的位置
            circle.lineWidth = 0.3
            circle.path = path.cgPath
            
            let animation = Self.rotateAnimation(factor,
                                                 x: (self.size-circleSize)/2, y: (self.size-circleSize)/2,
                                                 size: CGSize(width:self.size-circleSize,height:self.size-circleSize))
            layer.addSublayer(circle)
            
            circle.add(animation, forKey: "animation")
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public class func rotateAnimation(_ rate: Float,
                                                 x: CGFloat,
                                                 y: CGFloat,
                                              size: CGSize) -> CAAnimationGroup {
        let duration: CFTimeInterval = 1.5
        let fromScale = 1 - rate
        let toScale = 0.2 + rate
        let timeFunc = CAMediaTimingFunction(controlPoints: 0.5,0.15+rate,0.25,1)

        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = HUGE
        scaleAnimation.fromValue = fromScale
        scaleAnimation.toValue = toScale

        // Position animation
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = duration
        positionAnimation.repeatCount = HUGE
        positionAnimation.path = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                                 radius: size.width/2.0,
                                             startAngle: 3*Double.pi*0.5,
                                               endAngle: 3*Double.pi*0.5+2*Double.pi,
                                              clockwise: true).cgPath

        // Aniamtion
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, positionAnimation]
        animation.timingFunction = timeFunc
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        return animation
    }
}
