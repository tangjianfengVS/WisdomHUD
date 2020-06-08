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
        
        checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height, y: HUD_ImageWidth_Height/2))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: HUD_ImageWidth_Height/2, y: HUD_ImageWidth_Height/2),
                                  radius: (HUD_ImageWidth_Height-1)/2,
                                  startAngle: 0,
                                  endAngle: CGFloat(Double.pi*2),
                                  clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success:
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/4, y: HUD_ImageWidth_Height/2))
            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/5*2, y: HUD_ImageWidth_Height/3*2))
            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/4*3, y: HUD_ImageWidth_Height/3))
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/4, y: HUD_ImageWidth_Height/3))
            checkmarkShapePath.close()
        case .error:
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/3-1, y: HUD_ImageWidth_Height/3-1))
            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/3*2+1, y: HUD_ImageWidth_Height/3*2+1))
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/3-1, y: HUD_ImageWidth_Height/3*2+1))
            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/3*2+1, y: HUD_ImageWidth_Height/3-1))
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/3-1, y: HUD_ImageWidth_Height/3-1))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/2, y: 8))
            checkmarkShapePath.addLine(to: CGPoint(x: HUD_ImageWidth_Height/2, y: HUD_ImageWidth_Height/5*3))
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/2, y: 6))
            checkmarkShapePath.close()
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: HUD_ImageWidth_Height/2, y: HUD_ImageWidth_Height-8))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: HUD_ImageWidth_Height/2, y: HUD_ImageWidth_Height/5*3+4),
                                      radius: 1.2,
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
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: HUD_ImageWidth_Height, height: HUD_ImageWidth_Height), false, 0)
        WisdomHUDImage.draw(.success)
        HUD.imageOfSuccess = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return HUD.imageOfSuccess!
    }
    
    static var imageOfError : UIImage {
        
        guard HUD.imageOfError == nil else { return HUD.imageOfError! }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: HUD_ImageWidth_Height,height: HUD_ImageWidth_Height), false, 0)
        WisdomHUDImage.draw(.error)
        HUD.imageOfError = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return HUD.imageOfError!
    }
    
    static var imageOfInfo : UIImage {
        
        guard HUD.imageOfInfo == nil else { return HUD.imageOfInfo! }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: HUD_ImageWidth_Height,height: HUD_ImageWidth_Height), false, 0)
        WisdomHUDImage.draw(.info)
        HUD.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return HUD.imageOfInfo!
    }
    
}
