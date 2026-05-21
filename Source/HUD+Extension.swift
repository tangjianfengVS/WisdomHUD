//
//  HUD+Extension.swift
//  WisdomHUD
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//
//  跨平台辅助:布局约束、文字尺寸、Hex 颜色解析。
//  iOS/tvOS 走 UIKit,macOS 走 AppKit;视图/颜色/字体/EdgeInsets 通过 Able.swift 的
//  WisdomHUDView / WisdomHUDColor / WisdomHUDFont / WisdomHUDEdgeInsets 桥接。
//

#if os(iOS) || os(tvOS) || os(macOS)

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif


// MARK: - WisdomHUDView 布局/约束辅助

extension WisdomHUDView {

    // MARK: - set layout size
    @objc public func wisdom_addConstraint(width: CGFloat, height: CGFloat) {
        if width > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: width))
        }
        if height > 0 {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: height))
        }
    }
    
    // MARK: - set layout center
    @objc public func wisdom_addConstraint(toCenterX xView: WisdomHUDView?, toCenterY yView: WisdomHUDView?) {
        wisdom_addConstraint(toCenterX: xView, constantx: 0, toCenterY: yView, constanty: 0)
    }
    
    // MARK: - set layout center offset
    @objc public func wisdom_addConstraint(toCenterX xView: WisdomHUDView?,
                                           constantx: CGFloat,
                                           toCenterY yView: WisdomHUDView?,
                                           constanty: CGFloat) {
        if let xView = xView {
            addConstraint(NSLayoutConstraint(item: xView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: constantx))
        }
        if let yView = yView {
            addConstraint(NSLayoutConstraint(item: yView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: constanty))
        }
    }

    // MARK: - set layout edge inset
    @objc public func wisdom_addConstraint(to view: WisdomHUDView, edgeInset: WisdomHUDEdgeInsets) {
        wisdom_addConstraint(with: view,
                             topView: self,
                             leftView: self,
                             bottomView: self,
                             rightView: self,
                             edgeInset: edgeInset)
    }

    // MARK: - set layout edge inset to view
    @objc public func wisdom_addConstraint(with view: WisdomHUDView,
                                           topView: WisdomHUDView?,
                                           leftView: WisdomHUDView?,
                                           bottomView: WisdomHUDView?,
                                           rightView: WisdomHUDView?,
                                           edgeInset: WisdomHUDEdgeInsets) {
        let focusing = WisdomHUD_FocusingIdentifier()
        if let topView = topView {
            let topConstraint = NSLayoutConstraint(item: view,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: topView,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: edgeInset.top)
            topConstraint.identifier = focusing
            addConstraint(topConstraint)
        }
        if let leftView = leftView {
            let leftConstraint = NSLayoutConstraint(item: view,
                                                    attribute: .left,
                                                    relatedBy: .equal,
                                                    toItem: leftView,
                                                    attribute: .left,
                                                    multiplier: 1.0,
                                                    constant: edgeInset.left)
            leftConstraint.identifier = focusing
            addConstraint(leftConstraint)
        }
        if let bottomView = bottomView {
            let bottomConstraint = NSLayoutConstraint(item: view,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: bottomView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: edgeInset.bottom)
            bottomConstraint.identifier = focusing
            addConstraint(bottomConstraint)
        }
        if let rightView = rightView {
            let rightConstraint = NSLayoutConstraint(item: view,
                                                    attribute: .right,
                                                    relatedBy: .equal,
                                                    toItem: rightView,
                                                    attribute: .right,
                                                    multiplier: 1.0,
                                                    constant: edgeInset.right)
            rightConstraint.identifier = focusing
            addConstraint(rightConstraint)
        }
    }
}


// MARK: - 跨平台 backgroundColor 写入
// iOS/tvOS 直接写 backgroundColor;macOS 需 layer-backed,先确保 wantsLayer 再写 layer.backgroundColor

extension WisdomHUDView {

    @objc public func Wisdom_setBackgroundColor(_ color: WisdomHUDColor) {
        #if os(iOS) || os(tvOS)
        self.backgroundColor = color
        #elseif os(macOS)
        if !self.wantsLayer { self.wantsLayer = true }
        self.layer?.backgroundColor = color.cgColor
        #endif
    }
}


// MARK: - String 文字尺寸测量

extension String {

    // MARK: - Get Text Size With WisdomHUDFont
    public func wisdom_textSize(font: WisdomHUDFont, constrainedToSize size: CGSize) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        if size.equalTo(.zero) {
            return self.size(withAttributes: attributes)
        }
        let stringRect = self.boundingRect(with: size,
                                           options: .usesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil)
        return stringRect.size
    }
}


// MARK: - WisdomHUDColor hex 解析

extension WisdomHUDColor {

    // MARK: - Get Color with hex String
    @objc public static func wisdom_color(hex: String, alpha: CGFloat = 1) -> WisdomHUDColor {
        var color_hex = hex + "000000"
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            color_hex.removeFirst()
            color_hex.removeFirst()
        } else if hex.hasPrefix("#") {
            color_hex.removeFirst()
        }
        let start = color_hex.startIndex
        let end = color_hex.index(start, offsetBy: 6)
        color_hex = String(color_hex[start ..< end])

        let scanner = Scanner(string: color_hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return WisdomHUDColor(red: CGFloat(r) / 0xff,
                              green: CGFloat(g) / 0xff,
                              blue: CGFloat(b) / 0xff,
                              alpha: alpha)
    }
}


// MARK: - macOS 独有:NSBezierPath → CGPath(系统 14 以下没有内建 cgPath)

#if os(macOS)
extension NSBezierPath {

    @objc public var wisdom_cgPath: CGPath {
        let path = CGMutablePath()
        var points = [NSPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo, .cubicCurveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .quadraticCurveTo:
                path.addQuadCurve(to: points[1], control: points[0])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }
        return path
    }
}
#endif


// MARK: - Core 命名空间桥接:iOS 用 WisdomHUDCore,macOS 用 WisdomHUDMacCore

@inline(__always)
internal func WisdomHUD_FocusingIdentifier() -> String {
    #if os(iOS) || os(tvOS)
    return WisdomHUDCore.getWisdomHUD_Focusing()
    #elseif os(macOS)
    return WisdomHUDMacCore.getWisdomHUD_Focusing()
    #endif
}

#endif // os(iOS) || os(tvOS) || os(macOS)
