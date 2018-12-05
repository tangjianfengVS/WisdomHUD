//
//  WisdomHUDImage.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

class WisdomHUDImage {
    
    struct HUD {
        static var imageOfSuccess: UIImage?
        static var imageOfError: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    class func draw(_ type: WisdomHUDType) {
        let checkmarkShapePath = UIBezierPath()
        
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18),
                                  radius: 17.5,
                                  startAngle: 0,
                                  endAngle: CGFloat(Double.pi*2),
                                  clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27),
                                      radius: 1,
                                      startAngle: 0,
                                      endAngle: CGFloat(Double.pi*2),
                                      clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        case .loading:
            break
        case .text:
            break
        }
        let coverBarStyle = WisdomHUD.shared.coverBarStyle
        if coverBarStyle == .light {
            UIColor.black.setStroke()
        }else{
            UIColor.white.setStroke()
        }
        checkmarkShapePath.stroke()
    }
    
    static var imageOfSuccess: UIImage {
        
        guard HUD.imageOfSuccess == nil else {
            return HUD.imageOfSuccess!
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth_Height, height: imageWidth_Height), false, 0)
        WisdomHUDImage.draw(.success)
        HUD.imageOfSuccess = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return HUD.imageOfSuccess!
    }
    
    static var imageOfError : UIImage {
        
        guard HUD.imageOfError == nil else { return HUD.imageOfError! }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth_Height,
                                                      height: imageWidth_Height),
                                               false, 0)
        WisdomHUDImage.draw(.error)
        HUD.imageOfError = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return HUD.imageOfError!
    }
    
    static var imageOfInfo : UIImage {
        
        guard HUD.imageOfInfo == nil else { return HUD.imageOfInfo! }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth_Height,
                                                      height: imageWidth_Height),
                                               false, 0)
        WisdomHUDImage.draw(.info)
        HUD.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return HUD.imageOfInfo!
    }
    
}
