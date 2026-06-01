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
    private let barX: CGFloat
    private let barHeight: CGFloat = 6

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        self.barWidth = size * 1.6
        // 视图被 setProgressImage 钉成 icon_Size(=size)方形;进度条比视图宽,
        // 用 barX 让其相对视图水平居中(对称溢出),对齐 iOS 的 centerX 行为。
        self.barX = (size - barWidth) / 2
        super.init(size: size)

        let trackPath = NSBezierPath(roundedRect: NSRect(x: barX, y: (size - barHeight) / 2,
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
        let path = NSBezierPath(roundedRect: NSRect(x: barX, y: (size - barHeight) / 2,
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
// 对齐 iOS WisdomHUDImageWaterView:真实的贝塞尔水波。
// waterLayer 的 path 在两条左右相反的三次曲线之间往复动画(water_leftTopAnim),
// 通过 CATransaction 完成回调自循环(等价 iOS 的 CAAnimationDelegate 自循环)。
// 坐标:isFlipped=true 让 layer 用 top-left/y-down,与 iOS 路径坐标一致,直接复用。
@objc public final class WisdomHUDMacImageWaterView: WisdomHUDMacImageProgreView {

    private let bgLayer = CAShapeLayer()       // 空水位的容器底色(对应 iOS waterView.backgroundColor)
    private let trackLayer = CAShapeLayer()     // 圆形描边
    private let waterLayer = CAShapeLayer()     // 水波
    private let maskLayer = CAShapeLayer()       // 圆形裁剪
    private let textField = NSTextField(labelWithString: "0%")

    private let water_deep: CGFloat
    private let water_margin: CGFloat
    private let left_bottom_x: CGFloat
    private let right_top_x: CGFloat
    private var water_leftTopAnim = false
    private var progre: CGFloat = 0
    private var isRunning = false

    @objc public init(size: CGFloat, barStyle: WisdomSceneBarStyle) {
        water_deep = size / 3.2
        water_margin = size / 16
        left_bottom_x = (size / 16 + size) / 4
        right_top_x = (size / 16 + size) / 4 * 3
        super.init(size: size)
        wisdom_addConstraint(width: size, height: size)

        let circle = NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: size, height: size))

        bgLayer.path = circle.wisdom_cgPath
        bgLayer.fillColor = NSColor(white: 0.5, alpha: 0.3).cgColor
        layer?.addSublayer(bgLayer)

        waterLayer.fillColor = strokeColor(for: barStyle)
        waterLayer.strokeColor = strokeColor(for: barStyle)
        waterLayer.lineCap = .round
        waterLayer.lineWidth = 0.5
        waterLayer.frame = NSRect(x: -water_margin, y: 0, width: size + water_margin * 2, height: size)
        waterLayer.path = buildWavePath()
        layer?.addSublayer(waterLayer)

        trackLayer.path = circle.wisdom_cgPath
        trackLayer.fillColor = NSColor.clear.cgColor
        trackLayer.strokeColor = strokeColor(for: barStyle)
        trackLayer.lineWidth = 1
        layer?.addSublayer(trackLayer)

        maskLayer.path = circle.wisdom_cgPath
        layer?.mask = maskLayer

        textField.font = NSFont.systemFont(ofSize: size / 3.8)
        textField.textColor = textColor(for: barStyle)
        textField.alignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        wisdom_addConstraint(toCenterX: textField, toCenterY: textField)
        // 不在 init 启动:此时 window 还是 nil。进入窗口层级后由 viewDidMoveToWindow 启动,
        // 离开窗口(HUD dismiss)时自动停止,避免被持有的 context 让水波循环永久空转。
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if window != nil {
            if !isRunning {
                isRunning = true;
                runWave()
            }
        } else {
            isRunning = false
        }
    }

    public override func setProgreColor(color: NSColor) {
        waterLayer.fillColor = color.cgColor
        waterLayer.strokeColor = color.cgColor
    }

    public override func setProgreValue(value: UInt) {
        if value >= 100 {
            progre = 1
            textField.stringValue = "100%"
        } else {
            progre = CGFloat(value) / 100.0
            textField.stringValue = "\(value)%"
        }
    }

    public override func setProgreTextColor(color: NSColor) {
        textField.textColor = color
    }

    public override func setProgreShadowColor(color: NSColor) {
        bgLayer.fillColor = color.cgColor
    }

    // 构造一帧水波路径(坐标系沿用 iOS)。water_leftTopAnim 决定左右两个控制点的高低对调,
    // 从而在两帧间形成"晃动";progre 决定水面高度 y = size*(1-progre)。
    private func buildWavePath() -> CGPath {
        let surface = size * (1 - progre)
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 0, y: surface))
        if progre == 1 {
            path.line(to: NSPoint(x: water_margin * 2 + size, y: 0))
        } else if water_leftTopAnim {
            path.curve(to: NSPoint(x: water_margin * 2 + size, y: surface),
                       controlPoint1: NSPoint(x: left_bottom_x, y: (progre <= 0.1) ? surface - water_deep * 0.7 : surface - water_deep),
                       controlPoint2: NSPoint(x: right_top_x, y: (progre <= 0.1) ? surface + water_deep * 0.7 : surface + water_deep))
        } else {
            path.curve(to: NSPoint(x: water_margin * 2 + size, y: surface),
                       controlPoint1: NSPoint(x: left_bottom_x, y: (progre <= 0.1) ? surface + water_deep * 0.7 : surface + water_deep),
                       controlPoint2: NSPoint(x: right_top_x, y: (progre <= 0.1) ? surface - water_deep * 0.7 : surface - water_deep))
        }
        path.line(to: NSPoint(x: water_margin * 2 + size, y: size + water_deep / 3))
        path.line(to: NSPoint(x: 0, y: size + water_deep / 3))
        path.line(to: NSPoint(x: 0, y: surface + water_deep / 3))
        return path.wisdom_cgPath
    }

    private func runWave() {
        guard isRunning, window != nil else {
            isRunning = false;
            return
        }
        let toPath = buildWavePath()
        let anim = CABasicAnimation(keyPath: "path")
        anim.duration = 0.6
        anim.fromValue = waterLayer.path
        anim.toValue = toPath
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            // CATransaction 完成回调跑在 main thread,但闭包未带 @MainActor 标记
            MainActor.assumeIsolated {
                self?.runWave()
            }
        }
        waterLayer.path = toPath
        waterLayer.add(anim, forKey: "wave")
        CATransaction.commit()
        water_leftTopAnim.toggle()
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
