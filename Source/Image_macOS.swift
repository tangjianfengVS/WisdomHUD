//
//  Image_macOS.swift
//  WisdomHUD
//
//  根据 loading/progress 类型创建对应的图像 NSView,与 iOS Image.swift 对应。
//

#if os(macOS)
import AppKit


final class WisdomHUDMacImageView: NSView {

    private var imageView: WisdomHUDMacImageBaseView?

    override init(frame: NSRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override var isFlipped: Bool { true }
}

extension WisdomHUDMacImageView: @MainActor WisdomHUDMacSetImageable {

    func setLoadingImage(size: CGFloat, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle) {
        imageView?.removeFromSuperview()
        imageView = nil

        switch loadingStyle {
        case .system:      imageView = WisdomHUDMacIndicatorView(size: size, barStyle: barStyle)
        case .rotate:      imageView = WisdomHUDMacRotateView(size: size, barStyle: barStyle)
        case .progressArc: imageView = WisdomHUDMacProgressArcView(size: size, barStyle: barStyle)
        case .tadpoleArc:  imageView = WisdomHUDMacTadpoleArcView(size: size, barStyle: barStyle)
        case .chaseBall:   imageView = WisdomHUDMacChaseBallView(size: size, barStyle: barStyle)
        case .pulseBall:   imageView = WisdomHUDMacPulseBallView(size: size, barStyle: barStyle)
        case .pulseShape:  imageView = WisdomHUDMacPulseShapeView(size: size, barStyle: barStyle)
        }

        guard let v = imageView else { return }
        addSubview(v)
        if loadingStyle == .system {
            wisdom_addConstraint(toCenterX: v, toCenterY: v)
        } else {
            wisdom_addConstraint(with: v,
                                 topView: self, leftView: self,
                                 bottomView: self, rightView: self,
                                 edgeInset: NSEdgeInsetsZero)
        }
    }

    func setProgressImage(size: CGFloat, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle) {
        imageView?.removeFromSuperview()
        imageView = nil

        switch progreStyle {
        case .circle: imageView = WisdomHUDMacImageCircleView(size: size, barStyle: barStyle)
        case .linear: imageView = WisdomHUDMacImageLinearView(size: size, barStyle: barStyle)
        case .water:  imageView = WisdomHUDMacImageWaterView(size: size, barStyle: barStyle)
        }

        guard let v = imageView else { return }
        addSubview(v)
        wisdom_addConstraint(with: v,
                             topView: self, leftView: self,
                             bottomView: self, rightView: self,
                             edgeInset: NSEdgeInsetsZero)
    }

    func setSuccessImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        installStateView(WisdomHUDMacSuccessView(size: size, barStyle: barStyle))
    }

    func setErrorImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        installStateView(WisdomHUDMacErrorView(size: size, barStyle: barStyle))
    }

    func setWarningImage(size: CGFloat, barStyle: WisdomSceneBarStyle, animat: Bool) {
        installStateView(WisdomHUDMacWarningView(size: size, barStyle: barStyle))
    }

    private func installStateView(_ v: WisdomHUDMacImageAnimView) {
        imageView?.removeFromSuperview()
        imageView = v
        addSubview(v)
        wisdom_addConstraint(with: v,
                             topView: self, leftView: self,
                             bottomView: self, rightView: self,
                             edgeInset: NSEdgeInsetsZero)
        v.beginAnimation(isRepeat: false)
    }

    func setDismissImage() {
        (imageView as? WisdomHUDMacImageAnimView)?.endDismiss()
    }

    func setProgreColor(color: NSColor) {
        (imageView as? WisdomHUDMacImageProgreView)?.setProgreColor(color: color)
    }

    func setProgreValue(value: UInt) {
        (imageView as? WisdomHUDMacImageProgreView)?.setProgreValue(value: value)
    }

    func setProgreTextColor(color: NSColor) {
        (imageView as? WisdomHUDMacImageProgreView)?.setProgreTextColor(color: color)
    }

    func setProgreShadowColor(color: NSColor) {
        (imageView as? WisdomHUDMacImageProgreView)?.setProgreShadowColor(color: color)
    }
}

#endif
