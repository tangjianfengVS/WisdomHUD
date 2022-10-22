//
//  WisdomHUDImageAnim.swift
//  WisdomHUDDemo
//
//  Created by jianfeng tang on 2022/10/15.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit


// MARK: HUD IndicatorView: WisdomLoadingStyle.system
@objc public final class WisdomHUDIndicatorView: WisdomHUDImageBaseView {
    
    let indicatorView: UIActivityIndicatorView
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        var style: UIActivityIndicatorView.Style = .white
        if barStyle == .light {
            style = .gray
        }
        indicatorView = UIActivityIndicatorView(style: style)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        super.init(size: size)
        
        addSubview(indicatorView)
        wisdom_addConstraint(toCenterX: indicatorView, toCenterY: indicatorView)
    
        indicatorView.transform = CGAffineTransform.init(scaleX: size/20.0, y: size/20.0)
        indicatorView.startAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: HUD RotateView: WisdomLoadingStyle.rotate
@objc public final class WisdomHUDRotateView: WisdomHUDImageBaseView {
    
    private lazy var circleLayer: CAShapeLayer = {
        let lineWidth = getLineWidth()
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
        anim.delegate = self
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
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public override func getLineWidth()->CGFloat {
        return size/14.0
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return 0.6
    }
    
    @objc public override class func getLightColor()->CGColor{
        return UIColor.black.cgColor
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
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
        beginAnimation(isRepeat: true)
    }
}


// MARK: HUD ProgressArcView: WisdomLoadingStyle.progressArc
@objc public final class WisdomHUDProgressArcView: WisdomHUDImageBaseView {
    
    @objc public private(set) var lineColor: UIColor = UIColor.white
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        t.schedule(deadline: .now(), repeating: .milliseconds(70))
        t.setEventHandler(handler: { [weak self] in
            self?.setRotationAnim()
        })
        return t
    }()

    private lazy var originStart = { return origin }()

    private lazy var originEnd = { return origin+distance }()
    
    @objc public let origin = Double.pi*1.5
    
    @objc public let distance = Double.pi/8.0
    
    //private var animStart = false
    
    private lazy var circleLayer: CAShapeLayer = {
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = lineColor.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = getLineWidth()
        circle.strokeEnd = 1.0
        return circle
    }()
    
    private lazy var animation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = Self.getAnimDuration()
        anim.fromValue = 0
        anim.toValue = 1
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        anim.delegate = self
        anim.isRemovedOnCompletion = false
        return anim
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            lineColor = UIColor.white
        case .light:
            lineColor = UIColor.black
        case .hide:
            lineColor = UIColor.white
        }
        layer.addSublayer(circleLayer)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                   radius: size/2.0-getLineWidth(),
                               startAngle: origin,
                                 endAngle: Double.pi*3.5,
                                clockwise: true)
        circleLayer.path = path.cgPath
        
        arcAnimation()
    }
    
    private func arcAnimation() {
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setRotationAnim() {
        var start = true
        //if !animStart {
        //    if originEnd+distance < Double.pi*3.5 {
        //        originEnd = originEnd+distance
        //    }else if originEnd+distance >= Double.pi*3.5 {
        //        originEnd = origin//+(originEnd+distance-maxOrigin)
        //        originStart = originEnd+distance
        //        animStart = true
        //    }
        //} else {
            if originStart+distance < Double.pi*3.5 {
                originStart = originStart+distance
            }else if originStart+distance >= Double.pi*3.5 {
                originStart = origin//+(originStart+distance-maxOrigin)
                originEnd = Double.pi*3.5//originStart+distance
                start = false
            }
            
            let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                       radius: size/2.0-getLineWidth(),
                                   startAngle: originStart,
                                     endAngle: originEnd,
                                    clockwise: true)
            DispatchQueue.main.async { [weak self] in
                self?.circleLayer.path = path.cgPath
                
                if start == false {
                    self?.timer.suspend()
                    self?.arcAnimation()
                }
            }
        //}
    }
    
    @objc public override func getLineWidth()->CGFloat {
        return size/14.0
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return 0.75
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        originEnd = Double.pi*3.5
        originStart = origin
        timer.resume()
    }
    
    @objc public override func endDismiss() {
        timer.suspend()
        timer.cancel()
    }
}

extension WisdomHUDProgressArcView: CAAnimationDelegate {
    
    @objc public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        beginAnimation(isRepeat: false)
    }
}


// MARK: HUD TadpoleArcView: WisdomLoadingStyle.tadpoleArc
@objc public final class WisdomHUDTadpoleArcView: WisdomHUDImageBaseView {
    
    @objc public private(set) var fillColor: UIColor = UIColor.white
    
    @objc public private(set) var strokeColor: UIColor = UIColor.white

    @objc public private(set) lazy var distance = { return size/10.0 }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            fillColor = UIColor.white
            strokeColor = UIColor.darkGray
        case .light:
            fillColor = UIColor.black
            strokeColor = UIColor.lightGray
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
        beginAnimation(isRepeat: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func getLayerView() -> UIView {
        let topPoint = CGPoint(x: size/2+distance, y: distance/1.7)
        let inoutPoint = CGPoint(x: size-distance/2.5, y: (size-distance*2)/3*2.2+distance)
        let insidePoint = CGPoint(x: inoutPoint.x-getLineWidth(), y: (size-distance*2)/3*2.1+distance)
        
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
        circle.strokeColor = strokeColor.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = 0.3
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = UIColor.clear
        vi.layer.addSublayer(circle)
        return vi
    }
    
    @objc public override func getLineWidth()->CGFloat{
        return distance*0.74
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return 1.20
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi*2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = Self.getAnimDuration()
        rotationAnim.isRemovedOnCompletion = false
        layer.add(rotationAnim, forKey: nil)
    }
}


// MARK: HUD ChaseBallView: WisdomLoadingStyle.chaseBall
@objc public final class WisdomHUDChaseBallView: WisdomHUDImageBaseView {
    
    @objc public private(set) var ballColor: UIColor = UIColor.white
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            ballColor = UIColor.white
        case .light:
            ballColor = UIColor.black
        case .hide:
            ballColor = UIColor.white
        }
        beginAnimation(isRepeat: true)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public class func rotateAnimation(_ rate: Float,
                                                 x: CGFloat,
                                                 y: CGFloat,
                                              size: CGSize) -> CAAnimationGroup {
        let duration: CFTimeInterval = Self.getAnimDuration()
        let fromScale = 1 - rate
        let toScale = 0.25 + rate
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
    
    @objc public override func getLineWidth()->CGFloat{
        return size/5.5
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return 1.25
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        let circleSize = getLineWidth()
        // Draw circles
        for i in 0 ..< 5 {
            let factor = Float(i)*1/5
            let path: UIBezierPath = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: circleSize/2.0, y: circleSize/2.0),
                            radius: circleSize/2,
                        startAngle: 0,
                          endAngle: Double.pi*2,
                         clockwise: false)
            
            let circle = CAShapeLayer()
            circle.fillColor = ballColor.cgColor
            circle.strokeColor = ballColor.cgColor
            circle.lineCap = CAShapeLayerLineCap.round
            circle.strokeEnd = 1.0
            circle.lineWidth = 0.3
            circle.path = path.cgPath
            
            let animation = Self.rotateAnimation(factor,
                                                 x: (size-circleSize)/2, y: (size-circleSize)/2,
                                                 size: CGSize(width:size-circleSize, height:size-circleSize))
            layer.addSublayer(circle)
            
            circle.add(animation, forKey: "animation")
        }
    }
}


// MARK: HUD PulseBallView: WisdomLoadingStyle.pulseBall
@objc public final class WisdomHUDPulseBallView: WisdomHUDImageBaseView {
    
    @objc public private(set) var ballColor: UIColor = UIColor.white
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            ballColor = UIColor.white
        case .light:
            ballColor = UIColor.black
        case .hide:
            ballColor = UIColor.white
        }
        beginAnimation(isRepeat: true)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public override func getLineWidth()->CGFloat{
        return size/4.8
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return 0.75
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        let count: Int = 3
        let circleSize = getLineWidth()
        let circleSpacing: CGFloat = (size - circleSize * CGFloat(count))/CGFloat(count - 1)
        
        let duration: CFTimeInterval = Self.getAnimDuration()
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.keyTimes = [0, 0.2, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.2, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        // Draw circles
        for i in 0 ..< count {
            let path = UIBezierPath()
            path.addArc(withCenter: CGPoint(x: circleSize/2, y: circleSize/2),
                            radius: circleSize/2,
                        startAngle: 0,
                          endAngle: 2*Double.pi,
                         clockwise: false)
            
            let circle: CAShapeLayer = CAShapeLayer()
            circle.fillColor = ballColor.cgColor
            circle.path = path.cgPath
            
            let frame = CGRect(x: circleSpacing/5+(circleSpacing+circleSize-circleSpacing/5)*CGFloat(i),
                               y: (size-circleSize)/2,
                               width: circleSize,
                               height: circleSize)

            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            circle.add(animation, forKey: "animation")
            
            layer.addSublayer(circle)
        }
    }
}


// MARK: HUD PulseShapeView: WisdomLoadingStyle.pulseShape
@objc public final class WisdomHUDPulseShapeView: WisdomHUDImageBaseView {
    
    @objc public private(set) var ballColor: UIColor = UIColor.white
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:
            ballColor = UIColor.white
        case .light:
            ballColor = UIColor.black
        case .hide:
            ballColor = UIColor.white
        }
        beginAnimation(isRepeat: true)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public override func getLineWidth()->CGFloat{
        return size/6.1
    }
    
    @objc public override class func getAnimDuration()->CGFloat{
        return WisdomHUDPulseBallView.getAnimDuration()
    }
    
    @objc public override func beginAnimation(isRepeat: Bool){
        let count: Int = 3
        let shapeSize = getLineWidth()
        let lf_margin = shapeSize
        let middle_margin: CGFloat = (size-shapeSize*3.0-lf_margin)/2.0
        let heightSize: CGFloat = shapeSize*2.0
        
        let duration: CFTimeInterval = Self.getAnimDuration()
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.keyTimes = [0, 0.2, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.2, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        // Draw circles
        for i in 0 ..< count {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: lf_margin, y: 0))
            path.addLine(to: CGPoint(x: lf_margin+shapeSize, y: 0))
            
            path.addLine(to: CGPoint(x: shapeSize, y: heightSize))
            path.addLine(to: CGPoint(x: 0, y: heightSize))
            path.addLine(to: CGPoint(x: lf_margin, y: 0))
            
            let shape: CAShapeLayer = CAShapeLayer()
            shape.fillColor = ballColor.cgColor
            shape.path = path.cgPath
            
            let shapeFrame = CGRect(x: (shapeSize+middle_margin)*CGFloat(i),
                                    y: (size-heightSize)/2,
                                width: lf_margin+shapeSize,
                               height: heightSize)

            animation.beginTime = beginTime + beginTimes[i]
            shape.frame = shapeFrame
            shape.add(animation, forKey: "animation")
            
            layer.addSublayer(shape)
        }
    }
}
