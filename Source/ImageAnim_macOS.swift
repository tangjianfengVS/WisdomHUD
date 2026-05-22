//
//  ImageAnim_macOS.swift
//  WisdomHUD
//
//  AppKit 版 7 种 Loading 动画 + 3 个状态图标(success/error/warning)。
//  策略:
//   - 几何沿用 iOS 版的 CAShapeLayer 路径,坐标系靠 isFlipped=true 让 layer 用 top-left 原点
//     (与 iOS 保持一致,免得 path 上下颠倒)。
//   - WisdomHUDLoadingStyle.system:macOS 用 NSProgressIndicator(spinning) 替代菊花。
//

#if os(macOS)
import AppKit


// MARK: - 基类

public class WisdomHUDMacImageBaseView: NSView {

    @objc public let size: CGFloat

    @objc public init(size: CGFloat) {
        self.size = size
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override var isFlipped: Bool { true }
}


public class WisdomHUDMacImageAnimView: WisdomHUDMacImageBaseView {

    @objc public func getLineWidth() -> CGFloat { return 1.2 }

    @objc public class func getAnimDuration() -> CGFloat { return 0.8 }

    @objc public class func getLightColor() -> CGColor { return NSColor.black.cgColor }

    @objc public func beginAnimation(isRepeat: Bool) {}

    @objc public func endDismiss() {}
}


// MARK: - WisdomLoadingStyle.system → NSProgressIndicator
@objc public final class WisdomHUDMacIndicatorView: WisdomHUDMacImageAnimView {

    private let indicator = NSProgressIndicator()

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        indicator.style = .spinning
        indicator.controlSize = .regular
        indicator.isIndeterminate = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        // 反相主题让 spinner 颜色与卡片对比
        switch barStyle {
        case .light:
            indicator.appearance = NSAppearance(named: .aqua)
        case .dark, .hide:
            indicator.appearance = NSAppearance(named: .darkAqua)
        }
        addSubview(indicator)
        wisdom_addConstraint(toCenterX: indicator, toCenterY: indicator)
        indicator.startAnimation(nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func endDismiss() {
        indicator.stopAnimation(nil)
    }
}


// MARK: - WisdomLoadingStyle.rotate
@objc public final class WisdomHUDMacRotateView: WisdomHUDMacImageAnimView {

    private lazy var circleLayer: CAShapeLayer = {
        let lineWidth = getLineWidth()
        let path = NSBezierPath()
        addArc(to: path,
               center: CGPoint(x: size / 2, y: size / 2),
               radius: size / 2.0 - lineWidth,
               startAngle: 270,
               endAngle: 220,
               clockwise: false)
        let layer = CAShapeLayer()
        layer.fillColor = NSColor.clear.cgColor
        layer.strokeColor = NSColor.white.cgColor
        layer.lineCap = .round
        layer.lineWidth = lineWidth
        layer.strokeEnd = 1.0
        layer.path = path.wisdom_cgPath
        return layer
    }()

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        circleLayer.strokeColor = strokeColor(for: barStyle)
        layer?.addSublayer(circleLayer)

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.duration = 1
        circleLayer.add(rotation, forKey: "rotation")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 14.0 }

    public override class func getAnimDuration() -> CGFloat { return 0.6 }
}


// MARK: - WisdomLoadingStyle.progressArc
@objc public final class WisdomHUDMacProgressArcView: WisdomHUDMacImageAnimView {

    private let circleLayer = CAShapeLayer()

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        let lineWidth = getLineWidth()
        let path = NSBezierPath()
        addArc(to: path,
               center: CGPoint(x: size / 2, y: size / 2),
               radius: size / 2.0 - lineWidth,
               startAngle: 270,
               endAngle: 270 + 360,
               clockwise: false)
        circleLayer.fillColor = NSColor.clear.cgColor
        circleLayer.strokeColor = strokeColor(for: barStyle)
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.path = path.wisdom_cgPath
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0.05
        layer?.addSublayer(circleLayer)

        let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnim.fromValue = 0.05
        strokeAnim.toValue = 1
        strokeAnim.duration = 0.9
        strokeAnim.autoreverses = true
        strokeAnim.repeatCount = .greatestFiniteMagnitude
        circleLayer.add(strokeAnim, forKey: "stroke")

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 1.6
        rotation.repeatCount = .greatestFiniteMagnitude
        circleLayer.add(rotation, forKey: "rotation")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 14.0 }
}


// MARK: - WisdomLoadingStyle.tadpoleArc
@objc public final class WisdomHUDMacTadpoleArcView: WisdomHUDMacImageAnimView {

    private let circleLayer = CAShapeLayer()

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        let lineWidth = getLineWidth()
        let path = NSBezierPath()
        addArc(to: path,
               center: CGPoint(x: size / 2, y: size / 2),
               radius: size / 2.0 - lineWidth,
               startAngle: 270,
               endAngle: 230,
               clockwise: false)
        circleLayer.fillColor = NSColor.clear.cgColor
        circleLayer.strokeColor = strokeColor(for: barStyle)
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 1.0
        circleLayer.path = path.wisdom_cgPath
        layer?.addSublayer(circleLayer)

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.85
        rotation.repeatCount = .greatestFiniteMagnitude
        circleLayer.add(rotation, forKey: "rotation")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 11.0 }
}


// MARK: - WisdomLoadingStyle.chaseBall
@objc public final class WisdomHUDMacChaseBallView: WisdomHUDMacImageAnimView {

    private var dotLayers: [CAShapeLayer] = []

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        let dotCount = 8
        let dotRadius = size / 12
        let centerR = size / 2 - dotRadius - 1
        let color = strokeColor(for: barStyle)
        for i in 0 ..< dotCount {
            let angle = (Double(i) / Double(dotCount)) * Double.pi * 2 - Double.pi / 2
            let cx = size / 2 + cos(angle) * Double(centerR)
            let cy = size / 2 + sin(angle) * Double(centerR)
            let dot = CAShapeLayer()
            let path = NSBezierPath(ovalIn: NSRect(x: cx - Double(dotRadius),
                                                   y: cy - Double(dotRadius),
                                                   width: Double(dotRadius) * 2,
                                                   height: Double(dotRadius) * 2))
            dot.path = path.wisdom_cgPath
            dot.fillColor = color
            dot.opacity = Float(0.2 + 0.8 * Double(i) / Double(dotCount - 1))
            layer?.addSublayer(dot)
            dotLayers.append(dot)
        }
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 1.0
        rotation.repeatCount = .greatestFiniteMagnitude
        for d in dotLayers {
            d.add(rotation, forKey: "rotation")
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 12.0 }
}


// MARK: - WisdomLoadingStyle.pulseBall
@objc public final class WisdomHUDMacPulseBallView: WisdomHUDMacImageAnimView {

    private let ballLayer = CAShapeLayer()

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        let path = NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: size, height: size))
        ballLayer.path = path.wisdom_cgPath
        ballLayer.fillColor = strokeColor(for: barStyle)
        layer?.addSublayer(ballLayer)

        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0
        pulse.toValue = 1
        pulse.duration = 1.0
        pulse.repeatCount = .greatestFiniteMagnitude

        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1
        fade.toValue = 0
        fade.duration = 1.0
        fade.repeatCount = .greatestFiniteMagnitude

        let group = CAAnimationGroup()
        group.animations = [pulse, fade]
        group.duration = 1.0
        group.repeatCount = .greatestFiniteMagnitude
        ballLayer.add(group, forKey: "pulse")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}


// MARK: - WisdomLoadingStyle.pulseShape
@objc public final class WisdomHUDMacPulseShapeView: WisdomHUDMacImageAnimView {

    private let shapeLayer = CAShapeLayer()

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        let path = NSBezierPath(roundedRect: NSRect(x: size * 0.2, y: size * 0.2,
                                                    width: size * 0.6, height: size * 0.6),
                                xRadius: size * 0.1, yRadius: size * 0.1)
        shapeLayer.path = path.wisdom_cgPath
        shapeLayer.fillColor = strokeColor(for: barStyle)
        layer?.addSublayer(shapeLayer)

        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.7
        pulse.toValue = 1.2
        pulse.duration = 0.6
        pulse.autoreverses = true
        pulse.repeatCount = .greatestFiniteMagnitude

        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.4
        fade.toValue = 1.0
        fade.duration = 0.6
        fade.autoreverses = true
        fade.repeatCount = .greatestFiniteMagnitude

        let group = CAAnimationGroup()
        group.animations = [pulse, fade]
        group.duration = 0.6
        group.autoreverses = true
        group.repeatCount = .greatestFiniteMagnitude
        shapeLayer.add(group, forKey: "pulse")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
}


// MARK: - 3 个状态图标:Success / Error / Warning(描边动画)

@objc public final class WisdomHUDMacSuccessView: WisdomHUDMacImageAnimView {

    private lazy var circleLayer: CAShapeLayer = {
        let lineWidth = getLineWidth()
        let path = NSBezierPath()
        addArc(to: path,
               center: CGPoint(x: size / 2, y: size / 2),
               radius: (size - lineWidth) / 2,
               startAngle: 225,
               endAngle: 225 + 360,
               clockwise: false)
        path.move(to: NSPoint(x: size / 3.9, y: size / 2))
        path.line(to: NSPoint(x: size / 5 * 2.2, y: size / 3 * 2))
        path.line(to: NSPoint(x: size * 0.74, y: size / 2.7))

        let layer = CAShapeLayer()
        layer.fillColor = NSColor.clear.cgColor
        layer.strokeColor = NSColor.white.cgColor
        layer.lineCap = .round
        layer.lineWidth = lineWidth
        layer.strokeEnd = 1.0
        layer.path = path.wisdom_cgPath
        return layer
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
        circleLayer.strokeColor = strokeColor(for: barStyle)
        layer?.addSublayer(circleLayer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 24 }

    public override class func getAnimDuration() -> CGFloat { return 0.8 }

    public override func beginAnimation(isRepeat: Bool) {
        animation.repeatCount = isRepeat ? .greatestFiniteMagnitude : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}


@objc public final class WisdomHUDMacErrorView: WisdomHUDMacImageAnimView {

    private lazy var circleLayer: CAShapeLayer = {
        let lineWidth = getLineWidth()
        let path = NSBezierPath()
        addArc(to: path,
               center: CGPoint(x: size / 2, y: size / 2),
               radius: (size - lineWidth) / 2,
               startAngle: 225,
               endAngle: 225 + 360,
               clockwise: false)
        path.move(to: NSPoint(x: size / 3, y: size / 3))
        path.line(to: NSPoint(x: size / 3 * 2, y: size / 3 * 2))
        path.move(to: NSPoint(x: size / 3, y: size / 3 * 2))
        path.line(to: NSPoint(x: size / 3 * 2, y: size / 3))

        let layer = CAShapeLayer()
        layer.fillColor = NSColor.clear.cgColor
        layer.strokeColor = NSColor.white.cgColor
        layer.lineCap = .round
        layer.lineWidth = lineWidth
        layer.strokeEnd = 1.0
        layer.path = path.wisdom_cgPath
        return layer
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
        circleLayer.strokeColor = strokeColor(for: barStyle)
        layer?.addSublayer(circleLayer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 24 }

    public override class func getAnimDuration() -> CGFloat { return 0.8 }

    public override func beginAnimation(isRepeat: Bool) {
        animation.repeatCount = isRepeat ? .greatestFiniteMagnitude : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}


@objc public final class WisdomHUDMacWarningView: WisdomHUDMacImageAnimView {

    private lazy var circleLayer: CAShapeLayer = {
        let lineWidth = getLineWidth()
        let path = NSBezierPath()
        addArc(to: path,
               center: CGPoint(x: size / 2, y: size / 2),
               radius: (size - lineWidth) / 2,
               startAngle: 270,
               endAngle: 270 + 360,
               clockwise: false)
        path.move(to: NSPoint(x: size / 2 - 0.4, y: size / 4))
        path.line(to: NSPoint(x: size / 2, y: size / 3 * 1.7))
        path.move(to: NSPoint(x: size / 2 + 0.4, y: size / 4))
        path.line(to: NSPoint(x: size / 2, y: size / 3 * 1.7))

        let dotR = size / 30.0
        let dotRect = NSRect(x: size / 2 - dotR,
                             y: size / 3 * 2.1 + dotR - dotR,
                             width: dotR * 2,
                             height: dotR * 2)
        path.append(NSBezierPath(ovalIn: dotRect))

        let layer = CAShapeLayer()
        layer.fillColor = NSColor.clear.cgColor
        layer.strokeColor = NSColor.white.cgColor
        layer.lineCap = .round
        layer.lineWidth = lineWidth
        layer.strokeEnd = 1.0
        layer.path = path.wisdom_cgPath
        return layer
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
        circleLayer.strokeColor = strokeColor(for: barStyle)
        layer?.addSublayer(circleLayer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 24 }

    public override class func getAnimDuration() -> CGFloat { return 0.8 }

    public override func beginAnimation(isRepeat: Bool) {
        animation.repeatCount = isRepeat ? .greatestFiniteMagnitude : 1
        circleLayer.add(animation, forKey: "animateCircle")
    }
}


// MARK: - 内部辅助

fileprivate func strokeColor(for barStyle: WisdomSceneBarStyle) -> CGColor {
    switch barStyle {
    case .light:  return NSColor.black.cgColor
    case .dark:   return NSColor.white.cgColor
    case .hide:   return NSColor.white.cgColor
    }
}

// NSBezierPath 的 addArc 接收角度(度),与 CGPath/UIBezierPath(弧度)不同。
// 这里统一用度数,内部完成转换。clockwise 参数语义和 NSBezierPath 一致。
fileprivate func addArc(to path: NSBezierPath,
                        center: CGPoint,
                        radius: CGFloat,
                        startAngle: CGFloat,
                        endAngle: CGFloat,
                        clockwise: Bool) {
    path.appendArc(withCenter: NSPoint(x: center.x, y: center.y),
                   radius: radius,
                   startAngle: startAngle,
                   endAngle: endAngle,
                   clockwise: clockwise)
}

#endif
