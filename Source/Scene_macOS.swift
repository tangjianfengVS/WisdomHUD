//
//  Scene_macOS.swift
//  WisdomHUD
//
//  HUD 卡片视图(图标 + 文字)。AppKit 版,iOS Scene.swift 的对应实现。
//  布局策略与 iOS 一致:icon 在上,text 在下;text-only 时只放 textLabel。
//

#if os(macOS)
import AppKit


@MainActor
struct WisdomHUDMacContent {

    private(set) var bar_Size = CGSize(width: 97, height: 94)

    private(set) var icon_Size: CGFloat = 29

    let text_Font: CGFloat = CGFloat(WisdomHUDMacCore.WisdomTextSizeStyle.rawValue)

    let top_icon_space: CGFloat = 20

    let top_text_space: CGFloat = 11

    let lr_text_space: CGFloat = 12

    let bottom_text_space: CGFloat = 13

    fileprivate func getContentHeight() -> CGFloat {
        return top_icon_space + icon_Size + top_text_space + bottom_text_space
    }

    fileprivate mutating func updateIcon_Size(icon_Size: CGFloat, needUpdateBar: Bool = false) {
        self.icon_Size = icon_Size
        if needUpdateBar {
            self.bar_Size = CGSize(width: 97 + (97 - icon_Size) / 3.5, height: 94)
        }
    }
}


final class WisdomHUDMacSceneView: NSView {

    private(set) var content = WisdomHUDMacContent()

    let hudStyle: WisdomHUDStyle

    private var barStyle: WisdomSceneBarStyle

    private var loadingStyle: WisdomLoadingStyle?

    private var progreStyle: WisdomProgreStyle?

    private(set) var placeStyle: WisdomTextPlaceStyle?

    private var delayClosure: ((TimeInterval) -> ())?

    private var shadowColor: NSColor = .black

    private lazy var imageView: WisdomHUDMacImageView = {
        let v = WisdomHUDMacImageView(frame: .zero)
        addSubview(v)
        return v
    }()

    private lazy var textLabel: NSTextField = {
        let f = NSTextField(labelWithString: "")
        f.translatesAutoresizingMaskIntoConstraints = false
        f.textColor = .white
        f.alignment = .center
        f.maximumNumberOfLines = WisdomHUDMacCore.WisdomTextMaxLineStyle.rawValue
        f.lineBreakMode = .byWordWrapping
        f.preferredMaxLayoutWidth = textMaxWidth()
        addSubview(f)
        return f
    }()

    private lazy var widthConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
                                  toItem: nil, attribute: .notAnAttribute,
                                  multiplier: 1.0, constant: content.bar_Size.width)
    }()

    private lazy var heightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
                                  toItem: nil, attribute: .notAnAttribute,
                                  multiplier: 1.0, constant: content.bar_Size.height)
    }()

    init(hudStyle: WisdomHUDStyle, barStyle: WisdomSceneBarStyle, placeStyle: WisdomTextPlaceStyle?) {
        self.hudStyle = hudStyle
        self.barStyle = barStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        setStyleContent(barStyle: barStyle, placeStyle: placeStyle)

        addConstraint(widthConstraint)
        addConstraint(heightConstraint)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override var isFlipped: Bool { true }

    private func textMaxWidth() -> CGFloat {
        var w = (NSScreen.main?.frame.width ?? 800) * 0.45
        if w > 420 { w = 420 }
        return w
    }

    deinit { print("\(Swift.type(of: self)) deinit") }

    // MARK: 内部布局

    private func setImage_TextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        self.delayClosure = delayClosure

        wisdom_addConstraint(toCenterX: imageView, toCenterY: nil)
        imageView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal,
                                         toItem: self, attribute: .top,
                                         multiplier: 1.0, constant: content.top_icon_space))

        textLabel.stringValue = text
        textLabel.font = NSFont.systemFont(ofSize: content.text_Font, weight: .regular)

        wisdom_addConstraint(toCenterX: textLabel, toCenterY: nil)
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal,
                                         toItem: imageView, attribute: .bottom,
                                         multiplier: 1.0, constant: content.top_text_space))

        set_imageContentSize()
        set_shadowColor(cornerRadius: 10)
        startDelays(delays: delays)
    }

    private func set_TextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        self.delayClosure = delayClosure
        textLabel.stringValue = text
        textLabel.font = NSFont.systemFont(ofSize: content.text_Font, weight: .regular)

        wisdom_addConstraint(toCenterX: textLabel, toCenterY: textLabel)

        set_textContentSize()
        set_shadowColor(cornerRadius: 6)
        startDelays(delays: delays)
    }

    func set_imageContentSize() {
        layoutSubtreeIfNeeded()
        let textBounds = textLabel.intrinsicContentSize
        if textBounds.width + content.lr_text_space * 2 >= content.bar_Size.width {
            widthConstraint.constant = textBounds.width + content.lr_text_space * 2
        }
        if content.getContentHeight() + textBounds.height >= content.bar_Size.height {
            heightConstraint.constant = content.getContentHeight() + textBounds.height
        }
    }

    private func set_textContentSize() {
        widthConstraint.constant = 85
        heightConstraint.constant = 43

        layoutSubtreeIfNeeded()
        let textBounds = textLabel.intrinsicContentSize
        if textBounds.width + 15 * 2 >= widthConstraint.constant {
            widthConstraint.constant = textBounds.width + 15 * 2
        }
        if textBounds.height + 10 * 2 >= heightConstraint.constant {
            heightConstraint.constant = textBounds.height + 10 * 2
        }
    }

    private func set_shadowColor(cornerRadius: CGFloat) {
        layoutSubtreeIfNeeded()
        layer?.shadowColor = shadowColor.cgColor
        layer?.shadowOffset = CGSize(width: 0, height: 0)
        layer?.shadowOpacity = 1
        layer?.shadowRadius = 5
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = false
    }
}


// MARK: - 内容设置

extension WisdomHUDMacSceneView: @MainActor WisdomHUDMacContentable {

    func setLoadingContent(text: String, loadingStyle: WisdomLoadingStyle, timeout: (TimeInterval, (TimeInterval) -> ())?) {
        self.loadingStyle = loadingStyle
        if loadingStyle == .chaseBall {
            content.updateIcon_Size(icon_Size: content.icon_Size + 2.5)
        }
        imageView.setLoadingImage(size: content.icon_Size, loadingStyle: loadingStyle, barStyle: barStyle)
        imageView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)

        if text.isEmpty {
            wisdom_addConstraint(toCenterX: imageView, toCenterY: imageView)
        } else {
            wisdom_addConstraint(toCenterX: imageView, toCenterY: nil)
            addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: content.top_icon_space))
            textLabel.stringValue = text
            textLabel.font = NSFont.systemFont(ofSize: content.text_Font, weight: .regular)
            wisdom_addConstraint(toCenterX: textLabel, toCenterY: nil)
            addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal,
                                             toItem: imageView, attribute: .bottom,
                                             multiplier: 1.0, constant: content.top_text_space))
            set_imageContentSize()
        }
        set_shadowColor(cornerRadius: 10)

        if let t = timeout {
            _ = setTimeout(time: t.0, timeoutClosure: t.1)
        }
    }

    func setProgressContent(text: String, progreStyle: WisdomProgreStyle, timeout: (TimeInterval, (TimeInterval) -> ())?) {
        self.progreStyle = progreStyle
        content.updateIcon_Size(icon_Size: content.icon_Size * 1.7, needUpdateBar: !text.isEmpty)
        widthConstraint.constant = content.bar_Size.width
        heightConstraint.constant = content.bar_Size.height

        imageView.setProgressImage(size: content.icon_Size, progreStyle: progreStyle, barStyle: barStyle)
        imageView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)

        if text.isEmpty {
            wisdom_addConstraint(toCenterX: imageView, toCenterY: imageView)
        } else {
            wisdom_addConstraint(toCenterX: imageView, toCenterY: nil)
            addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: content.top_icon_space))
            textLabel.stringValue = text
            textLabel.font = NSFont.systemFont(ofSize: content.text_Font, weight: .regular)
            wisdom_addConstraint(toCenterX: textLabel, toCenterY: nil)
            addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal,
                                             toItem: imageView, attribute: .bottom,
                                             multiplier: 1.0, constant: content.top_text_space))
            set_imageContentSize()
        }
        set_shadowColor(cornerRadius: 10)

        if let t = timeout {
            _ = setTimeout(time: t.0, timeoutClosure: t.1)
        }
    }

    func setSuccessContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        imageView.setSuccessImage(size: content.icon_Size, barStyle: barStyle, animat: animat)
        setImage_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }

    func setErrorContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        imageView.setErrorImage(size: content.icon_Size, barStyle: barStyle, animat: animat)
        setImage_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }

    func setWarningContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        imageView.setWarningImage(size: content.icon_Size, barStyle: barStyle, animat: animat)
        setImage_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }

    func setTextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) {
        set_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }

    func setStyleContent(barStyle: WisdomSceneBarStyle, placeStyle: WisdomTextPlaceStyle?) {
        self.barStyle = barStyle
        self.placeStyle = placeStyle
        switch barStyle {
        case .dark:
            layer?.backgroundColor = NSColor.black.withAlphaComponent(0.90).cgColor
            textLabel.textColor = .white
            shadowColor = NSColor.white.withAlphaComponent(0.12)
        case .light:
            layer?.backgroundColor = NSColor.white.withAlphaComponent(0.95).cgColor
            textLabel.textColor = .black
            shadowColor = NSColor.black.withAlphaComponent(0.10)
        case .hide:
            layer?.backgroundColor = NSColor.clear.cgColor
            textLabel.textColor = .white
            shadowColor = .clear
        }
    }

    func setDismissImage() {
        if loadingStyle != nil || progreStyle != nil {
            imageView.setDismissImage()
        }
    }
}


// MARK: - Loading / Base / Progre Contextable on SceneView

extension WisdomHUDMacSceneView: @MainActor WisdomHUDMacLoadingContextable {

    func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval) -> ())) -> Self {
        self.delayClosure = timeoutClosure
        startDelays(delays: time)
        return self
    }

    func setTextFont(font: NSFont) -> Self {
        if !textLabel.stringValue.isEmpty {
            textLabel.font = font
            if hudStyle == .text {
                set_textContentSize()
            } else {
                set_imageContentSize()
            }
        }
        return self
    }

    func setTextColor(color: NSColor) -> Self {
        if !textLabel.stringValue.isEmpty {
            textLabel.textColor = color
        }
        return self
    }

    func setUpdateText(text: String) -> Self {
        textLabel.stringValue = text
        if hudStyle == .text {
            set_textContentSize()
        } else {
            set_imageContentSize()
        }
        return self
    }

    func setAnimation(view: NSView) -> Self {
        if hudStyle == .text { return self }
        imageView.removeFromSuperview()
        imageView.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)
        if textLabel.stringValue.isEmpty {
            wisdom_addConstraint(toCenterX: view, toCenterY: view)
        } else {
            wisdom_addConstraint(toCenterX: view, toCenterY: nil)
            addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: content.top_icon_space))
            addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal,
                                             toItem: view, attribute: .bottom,
                                             multiplier: 1.0, constant: content.top_text_space))
            set_imageContentSize()
        }
        return self
    }
}

extension WisdomHUDMacSceneView: @MainActor WisdomHUDMacProgreContextable {

    func setProgreColor(color: NSColor) -> Self {
        if progreStyle != nil { imageView.setProgreColor(color: color) }
        return self
    }

    func setProgreValue(value: UInt) -> Self {
        if progreStyle != nil { imageView.setProgreValue(value: value) }
        return self
    }

    func setProgreTextColor(color: NSColor) -> Self {
        if progreStyle != nil { imageView.setProgreTextColor(color: color) }
        return self
    }

    func setProgreShadowColor(color: NSColor) -> Self {
        if progreStyle != nil { imageView.setProgreShadowColor(color: color) }
        return self
    }
}


// MARK: - 自动消失

extension WisdomHUDMacSceneView: @MainActor WisdomHUDMacDelaysable {

    func startDelays(delays: TimeInterval) {
        // delays<=0 表示不自动消失
        if delays <= 0 { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delays) { [weak self] in
            guard let self = self else { return }
            NSAnimationContext.runAnimationGroup({ ctx in
                ctx.duration = 0.30
                self.superview?.animator().alphaValue = 0
            }, completionHandler: { [weak self] in
                // NSAnimationContext completion 实际跑在 main thread,但闭包类型未带 @MainActor 标记
                MainActor.assumeIsolated { self?.endAnimate(delays: delays) }
            })
        }
    }

    func endAnimate(delays: TimeInterval) {
        if let closure = delayClosure {
            closure(delays)
        }
        delayClosure = nil
        DispatchQueue.main.async { [weak self] in
            if self?.superview != nil {
                WisdomHUDMacCore.dismiss()
            }
        }
    }

    func executeDelayClosure() {
        if let closure = delayClosure {
            closure(-1)
        }
        delayClosure = nil
        setDismissImage()
    }
}

#endif
