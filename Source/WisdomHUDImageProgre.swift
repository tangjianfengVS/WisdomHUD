//
//  WisdomHUDImageProgre.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/6.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

public class WisdomHUDImageProgreView: WisdomHUDImageBaseView {
    
    private(set) var progreWidth: CGFloat=3.0
    
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
        wisdom_addConstraint(toCenterX: progreLabel, toCenterY: progreLabel)
        progreLabel.font = UIFont.systemFont(ofSize: size/4.2, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomHUDImageProgreView {
    
    @objc func setProgressValue(value: UInt){
    
    }
    
    @objc func setProgressColor(color: UIColor){
        
    }
    
    @objc func setProgressTextColor(color: UIColor){
        
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
        circle.strokeColor = UIColor(white: 0.5, alpha: 0.5).cgColor
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
        progreLabel.textColor = circleColor
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(task_circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override public func setProgressValue(value: UInt){
        if value>=100 {
            task_circleLayer.strokeEnd = 1
            progreLabel.text = "100%"
        }else {
            task_circleLayer.strokeEnd = CGFloat(value)/100.0
            progreLabel.text = "\(value)%"
        }
    }
    
    @objc override public func setProgressColor(color: UIColor){
        task_circleLayer.strokeColor = color.cgColor
    }
    
    @objc override public func setProgressTextColor(color: UIColor){
        progreLabel.textColor = color
    }
}