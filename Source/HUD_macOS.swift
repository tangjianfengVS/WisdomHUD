//
//  HUD_macOS.swift
//  WisdomHUD
//
//  macOS 原生提示 HUD 实现。与 iOS 共用 Config.swift 里的 enum,但完全独立的 NSView/NSWindow 渲染。
//  覆盖最常用 API:dismiss / showText / showSuccess / showError / showWarning / showLoading。
//  位置(WisdomTextPlaceStyle) + 主题(WisdomColorThemeStyle) + 自动消失。
//
//  iOS 上 typealias 同名 WisdomHUD 在 HUD.swift,本文件靠 #if os(macOS) 完全分离,无符号冲突。
//

#if os(macOS)
import AppKit


// MARK: - 公共入口
@objc public final class WisdomHUD: NSObject {

    @available(*, unavailable) override init() {}

    // MARK: 全局配置

    /// 自动消失延迟(秒)。0 = 不自动消失,需手动 dismiss
    @objc public static var displayDelay: TimeInterval = 1.5

    /// 默认主题(影响 HUD 卡片背景色)
    @objc public static var themeStyle: WisdomColorThemeStyle = .dark

    // MARK: dismiss

    /// 立即关闭当前 HUD(若有)
    @objc public static func dismiss() {
        WisdomHUDOverlay.shared.dismiss()
    }

    // MARK: 文本提示

    /// 纯文本(默认底部)
    @discardableResult
    @objc public static func showText(text: String) -> WisdomHUDMacContext {
        return show(style: .text, text: text, place: .bottom)
    }

    @discardableResult
    @objc public static func showText(text: String, placeStyle: WisdomTextPlaceStyle) -> WisdomHUDMacContext {
        return show(style: .text, text: text, place: placeStyle)
    }

    /// 与 iOS 同名:底部纯文本(对齐 HUD.swift `showTextBottom`)
    @discardableResult
    @objc public static func showTextBottom(text: String) -> WisdomHUDMacContext {
        return show(style: .text, text: text, place: .bottom)
    }

    // MARK: 状态提示

    @discardableResult
    @objc public static func showSuccess(text: String) -> WisdomHUDMacContext {
        return show(style: .succes, text: text, place: .center)
    }

    @discardableResult
    @objc public static func showError(text: String) -> WisdomHUDMacContext {
        return show(style: .error, text: text, place: .center)
    }

    @discardableResult
    @objc public static func showWarning(text: String) -> WisdomHUDMacContext {
        return show(style: .warning, text: text, place: .center)
    }

    // MARK: Loading

    @discardableResult
    @objc public static func showLoading(text: String) -> WisdomHUDMacContext {
        // loading 不自动消失,需手动 dismiss
        return show(style: .loading, text: text, place: .center, autoDismiss: false)
    }

    /// 与 iOS 同名重载,loadingStyle 在 macOS 当前实现下被忽略(只有一种 spinner 样式)
    @discardableResult
    @objc public static func showLoading(text: String, loadingStyle: WisdomLoadingStyle) -> WisdomHUDMacContext {
        return show(style: .loading, text: text, place: .center, autoDismiss: false)
    }

    // MARK: - 内部分发

    private static func show(style: WisdomHUDStyle,
                             text: String,
                             place: WisdomTextPlaceStyle,
                             autoDismiss: Bool = true) -> WisdomHUDMacContext {
        let ctx = WisdomHUDMacContext(style: style, text: text, place: place)
        WisdomHUDOverlay.shared.present(ctx, autoDismiss: autoDismiss, delay: displayDelay, theme: themeStyle)
        return ctx
    }
}


// MARK: - 调用方 handle(用于手动 dismiss / 修改文案)

@objcMembers
public final class WisdomHUDMacContext: NSObject {
    public let style: WisdomHUDStyle
    public fileprivate(set) var text: String
    public let place: WisdomTextPlaceStyle
    fileprivate weak var view: WisdomHUDMacView?

    init(style: WisdomHUDStyle, text: String, place: WisdomTextPlaceStyle) {
        self.style = style
        self.text = text
        self.place = place
        super.init()
    }

    /// 手动关闭
    public func dismiss() {
        DispatchQueue.main.async {
            WisdomHUDOverlay.shared.dismiss(context: self)
        }
    }

    /// 更新文案(仅当当前 HUD 仍是本 context 时生效)
    /// 自定义 ObjC selector 避免与 `text` 属性的合成 setter `setText:` 冲突
    @objc(updateHUDText:)
    public func setText(_ newText: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.text = newText
            self.view?.updateText(newText)
        }
    }

    /// 与 iOS WisdomHUDContextable.setFocusing() 链式 API 对齐;macOS 没有焦点遮罩概念,空操作返回自身
    @discardableResult
    public func setFocusing() -> Self {
        return self
    }
}


// MARK: - Overlay 单例:管理 NSPanel + 当前 HUD view

private final class WisdomHUDOverlay {
    static let shared = WisdomHUDOverlay()

    private var panel: NSPanel?
    private var currentView: WisdomHUDMacView?
    // 强引用,避免调用方丢弃返回值后 context 立刻释放导致自动消失失效
    private var currentContext: WisdomHUDMacContext?
    private var dismissWorkItem: DispatchWorkItem?
    // 每次 present 自增,异步动作(动画 completion / auto-dismiss)用它判断"我是否仍在当前世代",
    // 防止旧动画 completion 误关掉新 HUD。
    private var presentEpoch: UInt64 = 0
    // 监听 host window resize/move,让 panel 跟随
    private var hostObservers: [NSObjectProtocol] = []
    private weak var hostWindow: NSWindow?

    func present(_ context: WisdomHUDMacContext,
                 autoDismiss: Bool,
                 delay: TimeInterval,
                 theme: WisdomColorThemeStyle) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismissInternal(animated: false)

            guard let host = self.findHostWindow() else {
                NSLog("[WisdomHUD] no host NSWindow,放弃显示")
                return
            }

            self.presentEpoch &+= 1
            let panel = self.makeOrReusePanel(over: host)
            // 作为 host 的 child window 挂上去:跟随 host 显隐/层级,
            // app 失活时不会浮在别的应用上面;同时杜绝跨 Space 漂移
            if panel.parent !== host {
                panel.parent?.removeChildWindow(panel)
                host.addChildWindow(panel, ordered: .above)
            }
            self.attachHostObservers(host: host)
            let hud = WisdomHUDMacView(style: context.style, text: context.text, place: context.place, theme: theme)
            context.view = hud
            self.currentContext = context
            self.currentView = hud

            panel.contentView?.subviews.forEach { $0.removeFromSuperview() }
            if let content = panel.contentView {
                hud.translatesAutoresizingMaskIntoConstraints = false
                content.addSubview(hud)
                let placeAnchorY: NSLayoutYAxisAnchor
                let placeOffset: CGFloat
                switch context.place {
                case .center:
                    placeAnchorY = content.centerYAnchor
                    placeOffset = 0
                case .bottom:
                    placeAnchorY = content.bottomAnchor
                    placeOffset = -80
                @unknown default:
                    placeAnchorY = content.centerYAnchor
                    placeOffset = 0
                }
                NSLayoutConstraint.activate([
                    hud.centerXAnchor.constraint(equalTo: content.centerXAnchor),
                    placeOffset == 0
                        ? hud.centerYAnchor.constraint(equalTo: placeAnchorY)
                        : hud.bottomAnchor.constraint(equalTo: placeAnchorY, constant: placeOffset),
                ])
            }
            panel.alphaValue = 0
            panel.orderFrontRegardless()
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.duration = 0.18
                panel.animator().alphaValue = 1
            }

            if autoDismiss {
                self.scheduleAutoDismiss(after: delay, context: context)
            }
        }
    }

    func dismiss() {
        DispatchQueue.main.async { [weak self] in
            self?.dismissInternal(animated: true)
        }
    }

    func dismiss(context: WisdomHUDMacContext) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.currentContext === context else { return }
            self.dismissInternal(animated: true)
        }
    }

    // MARK: 私有

    private func scheduleAutoDismiss(after delay: TimeInterval, context: WisdomHUDMacContext) {
        dismissWorkItem?.cancel()
        let epoch = presentEpoch
        let work = DispatchWorkItem { [weak self] in
            guard let self = self, self.presentEpoch == epoch else { return }
            self.dismissInternal(animated: true)
        }
        dismissWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + max(0.1, delay), execute: work)
    }

    private func dismissInternal(animated: Bool) {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        guard let panel = panel else {
            currentView = nil
            currentContext = nil
            return
        }
        currentView?.stopSpinner()
        currentView = nil
        currentContext = nil
        // 用 epoch 锁定本次淡出对应的世代,完成回调时校验 — 防止旧动画 completion 误关新 HUD
        let epoch = presentEpoch
        if animated {
            NSAnimationContext.runAnimationGroup({ ctx in
                ctx.duration = 0.18
                panel.animator().alphaValue = 0
            }, completionHandler: { [weak self] in
                guard let self = self, self.presentEpoch == epoch else { return }
                self.panel?.orderOut(nil)
                self.panel?.contentView?.subviews.forEach { $0.removeFromSuperview() }
            })
        } else {
            panel.orderOut(nil)
            panel.contentView?.subviews.forEach { $0.removeFromSuperview() }
        }
    }

    private func attachHostObservers(host: NSWindow) {
        guard host !== hostWindow else { return }
        // 切宿主时清理旧 observer
        hostObservers.forEach { NotificationCenter.default.removeObserver($0) }
        hostObservers.removeAll()
        hostWindow = host
        let center = NotificationCenter.default
        let names: [Notification.Name] = [NSWindow.didResizeNotification, NSWindow.didMoveNotification, NSWindow.didChangeScreenNotification]
        for n in names {
            let token = center.addObserver(forName: n, object: host, queue: .main) { [weak self, weak host] _ in
                guard let self = self, let h = host, let p = self.panel else { return }
                p.setFrame(h.frame, display: false)
            }
            hostObservers.append(token)
        }
    }

    private func makeOrReusePanel(over host: NSWindow) -> NSPanel {
        if let p = panel {
            p.setFrame(host.frame, display: false)
            return p
        }
        let p = NSPanel(contentRect: host.frame,
                        styleMask: [.borderless, .nonactivatingPanel],
                        backing: .buffered,
                        defer: false)
        // 走 child window 路线:不需要 floating/跨 Space,
        // 跟随 host 自然层级,app 不在前台时也跟着隐藏
        p.isFloatingPanel = false
        p.hidesOnDeactivate = true
        p.hasShadow = false
        p.isOpaque = false
        p.backgroundColor = .clear
        // 必须拦截鼠标:HUD 显示期间禁止点穿到下层 app 内容
        p.ignoresMouseEvents = false
        p.collectionBehavior = [.fullScreenAuxiliary, .ignoresCycle]
        p.contentView = NSView(frame: .zero)
        panel = p
        return p
    }

    private func findHostWindow() -> NSWindow? {
        if let key = NSApp.keyWindow { return key }
        if let main = NSApp.mainWindow { return main }
        return NSApp.windows.first(where: { $0.isVisible })
    }
}


// MARK: - HUD 卡片视图(图标/spinner + 文本)

private final class WisdomHUDMacView: NSView {

    private let style: WisdomHUDStyle
    private let place: WisdomTextPlaceStyle
    private let theme: WisdomColorThemeStyle
    private let label = NSTextField(labelWithString: "")
    private var spinner: NSProgressIndicator?

    init(style: WisdomHUDStyle, text: String, place: WisdomTextPlaceStyle, theme: WisdomColorThemeStyle) {
        self.style = style
        self.place = place
        self.theme = theme
        super.init(frame: .zero)
        wantsLayer = true
        configureCard()
        configureContent(text: text)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    func updateText(_ text: String) {
        label.stringValue = text
    }

    func stopSpinner() {
        spinner?.stopAnimation(nil)
    }

    // MARK: 内部布局

    private func configureCard() {
        let bg: NSColor
        switch theme {
        case .dark:
            bg = NSColor(calibratedWhite: 0, alpha: 0.78)
        case .light:
            bg = NSColor(calibratedWhite: 1, alpha: 0.92)
        @unknown default:
            bg = NSColor(calibratedWhite: 0, alpha: 0.78)
        }
        layer?.backgroundColor = bg.cgColor
        layer?.cornerRadius = 10
        layer?.masksToBounds = true
    }

    private var labelTextColor: NSColor {
        return theme == .light ? .black : .white
    }

    private var iconTintColor: NSColor {
        return theme == .light ? .black : .white
    }

    private func configureContent(text: String) {
        label.stringValue = text
        label.textColor = labelTextColor
        label.font = NSFont.systemFont(ofSize: 14)
        label.alignment = .center
        label.lineBreakMode = .byWordWrapping
        label.maximumNumberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        switch style {
        case .text:
            // 仅文本,padding 14x10
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
                widthAnchor.constraint(lessThanOrEqualToConstant: 360),
            ])
        case .succes, .error, .warning:
            let icon = makeStateIcon(for: style)
            icon.translatesAutoresizingMaskIntoConstraints = false
            addSubview(icon)
            NSLayoutConstraint.activate([
                widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
                widthAnchor.constraint(lessThanOrEqualToConstant: 280),
                icon.topAnchor.constraint(equalTo: topAnchor, constant: 18),
                icon.centerXAnchor.constraint(equalTo: centerXAnchor),
                icon.widthAnchor.constraint(equalToConstant: 38),
                icon.heightAnchor.constraint(equalToConstant: 38),
                label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            ])
        case .loading:
            let s = NSProgressIndicator()
            s.style = .spinning
            s.controlSize = .regular
            s.isIndeterminate = true
            s.translatesAutoresizingMaskIntoConstraints = false
            // NSProgressIndicator 没有 contentTintColor;靠 appearance 强制反相主题让 spinner 自适应卡片色
            s.appearance = NSAppearance(named: theme == .light ? .aqua : .darkAqua)
            spinner = s
            addSubview(s)
            s.startAnimation(nil)
            // 用 .regular 的固有 32×32 — 强压 28×28 会让菊花在框内偏心
            let spinnerSide: CGFloat = 32
            if text.isEmpty {
                // 无文案:菊花在卡片正中,卡片自适应到菊花外圈 padding
                NSLayoutConstraint.activate([
                    widthAnchor.constraint(equalToConstant: spinnerSide + 32),
                    heightAnchor.constraint(equalToConstant: spinnerSide + 32),
                    s.centerXAnchor.constraint(equalTo: centerXAnchor),
                    s.centerYAnchor.constraint(equalTo: centerYAnchor),
                    s.widthAnchor.constraint(equalToConstant: spinnerSide),
                    s.heightAnchor.constraint(equalToConstant: spinnerSide),
                ])
            } else {
                NSLayoutConstraint.activate([
                    widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
                    widthAnchor.constraint(lessThanOrEqualToConstant: 280),
                    s.topAnchor.constraint(equalTo: topAnchor, constant: 18),
                    s.centerXAnchor.constraint(equalTo: centerXAnchor),
                    s.widthAnchor.constraint(equalToConstant: spinnerSide),
                    s.heightAnchor.constraint(equalToConstant: spinnerSide),
                    label.topAnchor.constraint(equalTo: s.bottomAnchor, constant: 10),
                    label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                    label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                ])
            }
        case .progress, .action:
            // 当前 macOS 版本未实现这两种,降级为纯文本
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
                widthAnchor.constraint(lessThanOrEqualToConstant: 360),
            ])
        @unknown default:
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            ])
        }
    }

    private func makeStateIcon(for style: WisdomHUDStyle) -> NSView {
        let symbolName: String
        switch style {
        case .succes:  symbolName = "checkmark.circle.fill"
        case .error:   symbolName = "xmark.octagon.fill"
        case .warning: symbolName = "exclamationmark.triangle.fill"
        default:       symbolName = "info.circle.fill"
        }
        if #available(macOS 11.0, *), let img = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil) {
            let iv = NSImageView()
            iv.image = img
            iv.contentTintColor = iconTintColor
            iv.imageScaling = .scaleProportionallyUpOrDown
            return iv
        }
        // macOS 10.x fallback:画一个圆 + 字符
        return DrawnIconView(style: style, color: iconTintColor)
    }
}


// MARK: - macOS 10.x fallback 图标(纯 CG 绘制,不依赖 SF Symbols)

private final class DrawnIconView: NSView {
    private let style: WisdomHUDStyle
    private let color: NSColor

    init(style: WisdomHUDStyle, color: NSColor) {
        self.style = style
        self.color = color
        super.init(frame: .zero)
        wantsLayer = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        ctx.setFillColor(color.cgColor)
        let inset = bounds.insetBy(dx: 1, dy: 1)
        ctx.strokeEllipse(in: inset)
        let symbol: String
        switch style {
        case .succes:  symbol = "✓"
        case .error:   symbol = "✕"
        case .warning: symbol = "!"
        default:       symbol = "i"
        }
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: bounds.width * 0.55),
            .foregroundColor: color
        ]
        let str = NSAttributedString(string: symbol, attributes: attrs)
        let size = str.size()
        let pt = NSPoint(x: (bounds.width - size.width) / 2, y: (bounds.height - size.height) / 2)
        str.draw(at: pt)
    }
}

#endif
