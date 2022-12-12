//
//  WisdomHUDImageProgre.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/6.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

public class WisdomHUDImageProgreView: WisdomHUDImageBaseView {
    
    fileprivate var progreWidth: CGFloat=3.0
    
    let progreLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(size: CGFloat) {
        super.init(size: size)
        addSubview(progreLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomHUDImageProgreView {
    
    @objc func setProgreValue(value: UInt){
    
    }
    
    @objc func setProgreColor(color: UIColor){
        
    }
    
    @objc func setProgreTextColor(color: UIColor){
        
    }
    
    @objc func setProgreShadowColor(color: UIColor){
        
    }
}

@objc public class WisdomHUDImageCircleView: WisdomHUDImageProgreView {

    @objc public private(set) var circleColor = UIColor.white
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                   radius: size/2.0-progreWidth,
                               startAngle: Double.pi,
                                 endAngle: Double.pi*3,
                                clockwise: true)

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor(white: 0.5, alpha: 0.3).cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = progreWidth
        circle.strokeEnd = 1.0
        circle.path = path.cgPath
        return circle
    }()
    
    private lazy var task_circleLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                   radius: size/2.0-progreWidth,
                               startAngle: Double.pi*1.5,
                                 endAngle: Double.pi*3.5,
                                clockwise: true)

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = circleColor.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = progreWidth
        circle.strokeEnd = 0
        circle.path = path.cgPath
        return circle
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark:  circleColor = UIColor.white
        case .light: circleColor = UIColor.black
        case .hide:  circleColor = UIColor.white
        }
        wisdom_addConstraint(toCenterX: progreLabel, toCenterY: progreLabel)
        progreLabel.font = UIFont.systemFont(ofSize: size/3.8, weight: .regular)
        progreLabel.textColor = circleColor
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(task_circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override public func setProgreValue(value: UInt){
        if value>=100 {
            task_circleLayer.strokeEnd = 1
            progreLabel.text = "100%"
        }else {
            task_circleLayer.strokeEnd = CGFloat(value)/100.0
            progreLabel.text = "\(value)%"
        }
    }
    
    @objc override public func setProgreColor(color: UIColor){
        task_circleLayer.strokeColor = color.cgColor
    }
    
    @objc override public func setProgreTextColor(color: UIColor){
        progreLabel.textColor = color
    }
    
    @objc override public func setProgreShadowColor(color: UIColor){
        circleLayer.strokeColor = color.cgColor
    }
}


@objc public class WisdomHUDImageLinearView: WisdomHUDImageProgreView {

    @objc public private(set) var lineColor = UIColor.white
    
    private lazy var progreHeight: CGFloat = { return 5.8 }()//size/7.7
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(white: 0.5, alpha: 0.3).cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = progreHeight/2
        return view
    }()
    
    private lazy var task_circleLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: progreHeight/2))
        path.addLine(to: CGPoint(x: progreWidth, y: progreHeight/2))

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = lineColor.cgColor
        circle.lineCap = CAShapeLayerLineCap.round
        circle.lineWidth = progreHeight
        circle.strokeEnd = 0
        circle.path = path.cgPath
        return circle
    }()
    
    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        progreWidth = size*1.2
        
        switch barStyle {
        case .dark:  lineColor = UIColor.white
        case .light: lineColor = UIColor.black
        case .hide:  lineColor = UIColor.white
        }
        progreLabel.textColor = lineColor
        progreLabel.font = UIFont.systemFont(ofSize: size/3.4, weight: .regular)
        
        addSubview(borderView)
        borderView.wisdom_addConstraint(width: progreWidth, height: progreHeight)
        
        wisdom_addConstraint(toCenterX: borderView, toCenterY: nil)
        
        addConstraint(NSLayoutConstraint(item: borderView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: -progreHeight*1.3))
        
        wisdom_addConstraint(toCenterX: progreLabel, toCenterY: nil)
        
        addConstraint(NSLayoutConstraint(item: progreLabel,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: borderView,
                                         attribute:.top,
                                         multiplier: 1.0,
                                         constant: -progreHeight*1.5))
        
        borderView.layer.addSublayer(task_circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override public func setProgreValue(value: UInt){
        if value>=100 {
            task_circleLayer.strokeEnd = 1
            progreLabel.text = "100%"
        }else {
            task_circleLayer.strokeEnd = CGFloat(value)/100.0
            progreLabel.text = "\(value)%"
        }
    }
    
    @objc override public func setProgreColor(color: UIColor){
        task_circleLayer.strokeColor = color.cgColor
    }
    
    @objc override public func setProgreTextColor(color: UIColor){
        progreLabel.textColor = color
    }
    
    @objc override public func setProgreShadowColor(color: UIColor){
        borderView.layer.borderColor = color.cgColor
    }
}
