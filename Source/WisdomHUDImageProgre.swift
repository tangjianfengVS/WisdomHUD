//
//  WisdomHUDImageProgre.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/6.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

public class WisdomHUDImageProgreView: WisdomHUDImageBaseView {
    
    var progreWidth: CGFloat=3.5
}

@objc public class WisdomHUDImageCircleView: WisdomHUDImageProgreView {

    @objc public private(set) var circleColor: UIColor = UIColor.white
    
    private lazy var circleLayer: CAShapeLayer = {
        let path = UIBezierPath(arcCenter: CGPoint(x: size/2, y: size/2),
                                   radius: size/2.0-progreWidth,
                               startAngle: Double.pi,
                                 endAngle: Double.pi*3,
                                clockwise: true)

        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.gray.cgColor
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
        case .dark:
            circleColor = UIColor.white
        case .light:
            circleColor = UIColor.black
        case .hide:
            circleColor = UIColor.white
        }
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
