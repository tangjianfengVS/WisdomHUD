//
//  ImageProgre_macOS.swift
//  WisdomHUD
//
//  AppKit 版进度视图:Circle / Linear / Water 三种 Progress style。
//  和 iOS 版一样,通过 setProgreValue/Color/TextColor/ShadowColor 链式更新。
//

#if os(macOS)
import AppKit


public class WisdomHUDMacImageProgreView: WisdomHUDMacImageBaseView {

    @objc public func setProgreColor(color: NSColor) {}

    @objc public func setProgreValue(value: UInt) {}

    @objc public func setProgreTextColor(color: NSColor) {}

    @objc public func setProgreShadowColor(color: NSColor) {}
}


// MARK: - WisdomProgreStyle.circle  环形进度
@objc public final class WisdomHUDMacImageCircleView: WisdomHUDMacImageProgreView {

    private let trackLayer = CAShapeLayer()
    private let progreLayer = CAShapeLayer()
    private let textField = NSTextField(labelWithString: "0%")
    private var lastValue: UInt = 0

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        wisdom_addConstraint(width: size, height: size)

        let lineWidth = size / 18
        let path = NSBezierPath()
        path.appendArc(withCenter: NSPoint(x: size / 2, y: size / 2),
                       radius: (size - lineWidth) / 2,
                       startAngle: 270,
                       endAngle: 270 + 360,
                       clockwise: false)

        trackLayer.path = path.wisdom_cgPath
        trackLayer.strokeColor = trackColor(for: barStyle)
        trackLayer.fillColor = NSColor.clear.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round
        layer?.addSublayer(trackLayer)

        progreLayer.path = path.wisdom_cgPath
        progreLayer.strokeColor = strokeColor(for: barStyle)
        progreLayer.fillColor = NSColor.clear.cgColor
        progreLayer.lineWidth = lineWidth
        progreLayer.lineCap = .round
        progreLayer.strokeEnd = 0
        layer?.addSublayer(progreLayer)

        textField.font = NSFont.systemFont(ofSize: size / 4.5)
        textField.textColor = textColor(for: barStyle)
        textField.alignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        wisdom_addConstraint(toCenterX: textField, toCenterY: textField)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func setProgreColor(color: NSColor) {
        progreLayer.strokeColor = color.cgColor
    }

    public override func setProgreValue(value: UInt) {
        let v = min(value, 100)
        lastValue = v
        let pct = CGFloat(v) / 100.0
        progreLayer.strokeEnd = pct
        textField.stringValue = "\(v)%"
    }

    public override func setProgreTextColor(color: NSColor) {
        textField.textColor = color
    }

    public override func setProgreShadowColor(color: NSColor) {
        trackLayer.strokeColor = color.cgColor
    }
}


// MARK: - WisdomProgreStyle.linear  线性进度
@objc public final class WisdomHUDMacImageLinearView: WisdomHUDMacImageProgreView {

    private let trackLayer = CAShapeLayer()
    private let progreLayer = CAShapeLayer()
    private let textField = NSTextField(labelWithString: "0%")
    private let barWidth: CGFloat
    private let barHeight: CGFloat = 6

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.barWidth = size * 1.6
        super.init(size: size)
        wisdom_addConstraint(width: barWidth, height: size)

        let trackPath = NSBezierPath(roundedRect: NSRect(x: 0, y: (size - barHeight) / 2,
                                                         width: barWidth, height: barHeight),
                                     xRadius: barHeight / 2, yRadius: barHeight / 2)
        trackLayer.path = trackPath.wisdom_cgPath
        trackLayer.fillColor = trackColor(for: barStyle)
        layer?.addSublayer(trackLayer)

        progreLayer.fillColor = strokeColor(for: barStyle)
        layer?.addSublayer(progreLayer)
        updateProgrePath(width: 0)

        textField.font = NSFont.systemFont(ofSize: size / 5)
        textField.textColor = textColor(for: barStyle)
        textField.alignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        addConstraint(NSLayoutConstraint(item: textField, attribute: .centerX, relatedBy: .equal,
                                         toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal,
                                         toItem: self, attribute: .top, multiplier: 1, constant: 0))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func updateProgrePath(width: CGFloat) {
        let w = max(0, min(barWidth, width))
        let path = NSBezierPath(roundedRect: NSRect(x: 0, y: (size - barHeight) / 2,
                                                    width: w, height: barHeight),
                                xRadius: barHeight / 2, yRadius: barHeight / 2)
        progreLayer.path = path.wisdom_cgPath
    }

    public override func setProgreColor(color: NSColor) {
        progreLayer.fillColor = color.cgColor
    }

    public override func setProgreValue(value: UInt) {
        let v = min(value, 100)
        let pct = CGFloat(v) / 100.0
        updateProgrePath(width: barWidth * pct)
        textField.stringValue = "\(v)%"
    }

    public override func setProgreTextColor(color: NSColor) {
        textField.textColor = color
    }

    public override func setProgreShadowColor(color: NSColor) {
        trackLayer.fillColor = color.cgColor
    }
}


// MARK: - WisdomProgreStyle.water  水球进度(简化版:用 CALayer mask 升起的色块替代水波)
@objc public final class WisdomHUDMacImageWaterView: WisdomHUDMacImageProgreView {

    private let trackLayer = CAShapeLayer()
    private let waterLayer = CALayer()
    private let maskLayer = CAShapeLayer()
    private let textField = NSTextField(labelWithString: "0%")

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        super.init(size: size)
        wisdom_addConstraint(width: size, height: size)

        let circle = NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: size, height: size))
        trackLayer.path = circle.wisdom_cgPath
        trackLayer.fillColor = NSColor.clear.cgColor
        trackLayer.strokeColor = strokeColor(for: barStyle)
        trackLayer.lineWidth = 1
        layer?.addSublayer(trackLayer)

        waterLayer.frame = NSRect(x: 0, y: size, width: size, height: 0)
        waterLayer.backgroundColor = strokeColor(for: barStyle)
        layer?.addSublayer(waterLayer)

        maskLayer.path = circle.wisdom_cgPath
        layer?.mask = maskLayer

        textField.font = NSFont.systemFont(ofSize: size / 4.5)
        textField.textColor = textColor(for: barStyle)
        textField.alignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        wisdom_addConstraint(toCenterX: textField, toCenterY: textField)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func setProgreColor(color: NSColor) {
        waterLayer.backgroundColor = color.cgColor
    }

    public override func setProgreValue(value: UInt) {
        let v = min(value, 100)
        let h = CGFloat(v) / 100.0 * size
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        // 由于 isFlipped=true,layer 用 top-left 坐标,水从底部上升 = 从 (size-h) 向下 h
        waterLayer.frame = NSRect(x: 0, y: size - h, width: size, height: h)
        CATransaction.commit()
        textField.stringValue = "\(v)%"
    }

    public override func setProgreTextColor(color: NSColor) {
        textField.textColor = color
    }

    public override func setProgreShadowColor(color: NSColor) {
        trackLayer.strokeColor = color.cgColor
    }
}


// MARK: - 辅助

fileprivate func strokeColor(for barStyle: WisdomSceneBarStyle) -> CGColor {
    switch barStyle {
    case .light: return NSColor.black.cgColor
    case .dark, .hide: return NSColor.white.cgColor
    }
}

fileprivate func trackColor(for barStyle: WisdomSceneBarStyle) -> CGColor {
    switch barStyle {
    case .light: return NSColor(white: 0, alpha: 0.15).cgColor
    case .dark, .hide: return NSColor(white: 1, alpha: 0.20).cgColor
    }
}

fileprivate func textColor(for barStyle: WisdomSceneBarStyle) -> NSColor {
    switch barStyle {
    case .light: return .black
    case .dark, .hide: return .white
    }
}

#endif
