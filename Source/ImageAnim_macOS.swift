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

        // 对齐 iOS:首帧 strokeEnd 0→1 的描边"画出"过场,与旋转叠加。
        let draw = CABasicAnimation(keyPath: "strokeEnd")
        draw.fromValue = 0
        draw.toValue = 1
        draw.duration = CFTimeInterval(Self.getAnimDuration())
        draw.timingFunction = CAMediaTimingFunction(name: .linear)
        circleLayer.add(draw, forKey: "draw")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 14.0 }

    public override class func getAnimDuration() -> CGFloat { return 0.6 }

    public override class func getLightColor() -> CGColor { return NSColor.black.cgColor }
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
// 对齐 iOS:3 条蝌蚪形描边,分别静态旋转 0/120/240°,整体再持续旋转。
@objc public final class WisdomHUDMacTadpoleArcView: WisdomHUDMacImageAnimView {

    private var tadFillColor: CGColor = NSColor.white.cgColor
    private var tadStrokeColor: CGColor = NSColor.darkGray.cgColor
    private let container = CALayer()
    private var distance: CGFloat { return size / 10.0 }

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        switch barStyle {
        case .dark, .hide:
            tadFillColor = NSColor.white.cgColor
            tadStrokeColor = NSColor.darkGray.cgColor
        case .light:
            tadFillColor = NSColor.black.cgColor
            tadStrokeColor = NSColor.lightGray.cgColor
        }
        container.frame = CGRect(x: 0, y: 0, width: size, height: size)
        container.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        container.position = CGPoint(x: size / 2, y: size / 2)
        layer?.addSublayer(container)

        for i in 0 ..< 3 {
            let arm = makeArm()
            arm.frame = CGRect(x: 0, y: 0, width: size, height: size)
            arm.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            arm.position = CGPoint(x: size / 2, y: size / 2)
            arm.transform = CATransform3DMakeRotation(CGFloat.pi / 180 * 120 * CGFloat(i), 0, 0, 1)
            container.addSublayer(arm)
        }
        beginAnimation(isRepeat: true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func makeArm() -> CAShapeLayer {
        let d = distance
        let lw = getLineWidth()
        let topPoint = NSPoint(x: size / 2 + d, y: d / 1.7)
        let inoutPoint = NSPoint(x: size - d / 2.5, y: (size - d * 2) / 3 * 2.2 + d)
        let insidePoint = NSPoint(x: inoutPoint.x - lw, y: (size - d * 2) / 3 * 2.1 + d)

        let path = NSBezierPath()
        path.move(to: topPoint)
        appendQuadCurve(to: path, end: inoutPoint, control: NSPoint(x: size + d * 0.6, y: size / 4.8))
        let width = inoutPoint.x - insidePoint.x
        let height = inoutPoint.y - insidePoint.y
        addArc(to: path,
               center: CGPoint(x: insidePoint.x + width / 2, y: insidePoint.y + height / 2),
               radius: sqrt(width * width + height * height) / 2,
               startAngle: 396,   // iOS 2.2π
               endAngle: 216,     // iOS 1.2π
               clockwise: true)
        appendQuadCurve(to: path, end: topPoint, control: NSPoint(x: size + d * 0.2, y: size / 4.6))

        let shape = CAShapeLayer()
        shape.fillColor = tadFillColor
        shape.strokeColor = tadStrokeColor
        shape.lineCap = .round
        shape.lineWidth = 0.3
        shape.strokeEnd = 1.0
        shape.path = path.wisdom_cgPath
        return shape
    }

    public override func getLineWidth() -> CGFloat { return distance * 0.74 }

    public override class func getAnimDuration() -> CGFloat { return 1.20 }

    public override func beginAnimation(isRepeat: Bool) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.duration = CFTimeInterval(Self.getAnimDuration())
        rotation.isRemovedOnCompletion = false
        container.add(rotation, forKey: "rotation")
    }
}


// MARK: - WisdomLoadingStyle.chaseBall
// 对齐 iOS:5 个小球沿同一圆轨道运动,各自 scale 区间与缓动不同,形成"追逐"效果。
@objc public final class WisdomHUDMacChaseBallView: WisdomHUDMacImageAnimView {

    private var ballColor: CGColor = NSColor.white.cgColor

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        ballColor = strokeColor(for: barStyle)
        beginAnimation(isRepeat: true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 5.5 }

    public override class func getAnimDuration() -> CGFloat { return 1.25 }

    // 单个小球的 scale + position(沿圆轨道)组合动画。
    private func orbitAnimation(_ rate: Float, x: CGFloat, y: CGFloat, orbit: CGFloat) -> CAAnimationGroup {
        let duration = CFTimeInterval(Self.getAnimDuration())
        let fromScale = 1 - rate
        let toScale = 0.25 + rate
        let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + rate, 0.25, 1)

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        scaleAnimation.fromValue = fromScale
        scaleAnimation.toValue = toScale

        // 圆形轨道(用 CGPath,弧度语义,与 iOS 一致)
        let orbitPath = CGMutablePath()
        orbitPath.addArc(center: CGPoint(x: x, y: y), radius: orbit / 2.0,
                         startAngle: 3 * Double.pi * 0.5,
                         endAngle: 3 * Double.pi * 0.5 + 2 * Double.pi,
                         clockwise: false)
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = duration
        positionAnimation.repeatCount = .greatestFiniteMagnitude
        positionAnimation.path = orbitPath

        let group = CAAnimationGroup()
        group.animations = [scaleAnimation, positionAnimation]
        group.timingFunction = timeFunc
        group.duration = duration
        group.repeatCount = .greatestFiniteMagnitude
        group.isRemovedOnCompletion = false
        return group
    }

    public override func beginAnimation(isRepeat: Bool) {
        let circleSize = getLineWidth()
        for i in 0 ..< 5 {
            let factor = Float(i) * 1 / 5
            let circle = CAShapeLayer()
            circle.path = NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: circleSize, height: circleSize)).wisdom_cgPath
            circle.fillColor = ballColor
            circle.bounds = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
            let anim = orbitAnimation(factor,
                                      x: (size - circleSize) / 2, y: (size - circleSize) / 2,
                                      orbit: size - circleSize)
            layer?.addSublayer(circle)
            circle.add(anim, forKey: "animation")
        }
    }
}


// MARK: - WisdomLoadingStyle.pulseBall
// 对齐 iOS:3 个圆点横向排列,scale 关键帧 [1,0.2,1] 错峰脉冲(经典三点 loading)。
@objc public final class WisdomHUDMacPulseBallView: WisdomHUDMacImageAnimView {

    private var ballColor: CGColor = NSColor.white.cgColor

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        ballColor = strokeColor(for: barStyle)
        beginAnimation(isRepeat: true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 4.8 }

    public override class func getAnimDuration() -> CGFloat { return 0.75 }

    public override func beginAnimation(isRepeat: Bool) {
        let count = 3
        let circleSize = getLineWidth()
        let circleSpacing = (size - circleSize * CGFloat(count)) / CGFloat(count - 1)
        let duration = CFTimeInterval(Self.getAnimDuration())
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)

        for i in 0 ..< count {
            let circle = CAShapeLayer()
            circle.path = NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: circleSize, height: circleSize)).wisdom_cgPath
            circle.fillColor = ballColor
            circle.frame = CGRect(x: circleSpacing / 5 + (circleSpacing + circleSize - circleSpacing / 5) * CGFloat(i),
                                  y: (size - circleSize) / 2,
                                  width: circleSize, height: circleSize)

            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.keyTimes = [0, 0.2, 1]
            animation.timingFunctions = [timingFunction, timingFunction]
            animation.values = [1, 0.2, 1]
            animation.duration = duration
            animation.repeatCount = .greatestFiniteMagnitude
            animation.isRemovedOnCompletion = false
            animation.beginTime = beginTime + beginTimes[i]
            circle.add(animation, forKey: "pulse")

            layer?.addSublayer(circle)
        }
    }
}


// MARK: - WisdomLoadingStyle.pulseShape
// 对齐 iOS:3 个平行四边形横向排列,scale 关键帧 [1,0.2,1] 错峰脉冲。
@objc public final class WisdomHUDMacPulseShapeView: WisdomHUDMacImageAnimView {

    private var ballColor: CGColor = NSColor.white.cgColor

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        ballColor = strokeColor(for: barStyle)
        beginAnimation(isRepeat: true)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func getLineWidth() -> CGFloat { return size / 6.1 }

    public override class func getAnimDuration() -> CGFloat { return WisdomHUDMacPulseBallView.getAnimDuration() }

    public override func beginAnimation(isRepeat: Bool) {
        let count = 3
        let shapeSize = getLineWidth()
        let lf_margin = shapeSize
        let middle_margin = (size - shapeSize * 3.0 - lf_margin) / 2.0
        let heightSize = shapeSize * 2.0

        let duration = CFTimeInterval(Self.getAnimDuration())
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)

        for i in 0 ..< count {
            let path = NSBezierPath()
            path.move(to: NSPoint(x: lf_margin, y: 0))
            path.line(to: NSPoint(x: lf_margin + shapeSize, y: 0))
            path.line(to: NSPoint(x: shapeSize, y: heightSize))
            path.line(to: NSPoint(x: 0, y: heightSize))
            path.line(to: NSPoint(x: lf_margin, y: 0))

            let shape = CAShapeLayer()
            shape.fillColor = ballColor
            shape.path = path.wisdom_cgPath
            shape.frame = CGRect(x: (shapeSize + middle_margin) * CGFloat(i),
                                 y: (size - heightSize) / 2,
                                 width: lf_margin + shapeSize, height: heightSize)

            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.keyTimes = [0, 0.2, 1]
            animation.timingFunctions = [timingFunction, timingFunction]
            animation.values = [1, 0.2, 1]
            animation.duration = duration
            animation.repeatCount = .greatestFiniteMagnitude
            animation.isRemovedOnCompletion = false
            animation.beginTime = beginTime + beginTimes[i]
            shape.add(animation, forKey: "pulse")

            layer?.addSublayer(shape)
        }
    }
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

// NSBezierPath 没有二次贝塞尔 API,把 iOS 的 addQuadCurve 转成等价三次曲线。
// 二次 (P0,控制 C,P1) → 三次 C1=P0+2/3(C-P0), C2=P1+2/3(C-P1)。
fileprivate func appendQuadCurve(to path: NSBezierPath, end: NSPoint, control c: NSPoint) {
    let start = path.currentPoint
    let c1 = NSPoint(x: start.x + 2.0 / 3.0 * (c.x - start.x), y: start.y + 2.0 / 3.0 * (c.y - start.y))
    let c2 = NSPoint(x: end.x + 2.0 / 3.0 * (c.x - end.x), y: end.y + 2.0 / 3.0 * (c.y - end.y))
    path.curve(to: end, controlPoint1: c1, controlPoint2: c2)
}

#endif
