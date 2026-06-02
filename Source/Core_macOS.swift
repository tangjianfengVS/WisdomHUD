//
//  Core_macOS.swift
//  WisdomHUD
//
//  内核调度:全局配置 + window 寻址 + cover/scene 创建复用 + 11 类 show* 工厂。
//  AppKit 版,iOS Core.swift 对应。
//
//  Window 模型差异:iOS 是把 cover view 加到 keyWindow 的 root view 上;
//  macOS 这里复用 HUD_macOS.swift 已经搭好的 NSPanel 路线 —
//  把 cover view 挂到 host 的 contentView 内,通过 child window 的 NSPanel 渲染。
//

#if os(macOS)
import AppKit


struct WisdomHUDMacCore {

    // MARK: 全局配置(对齐 iOS WisdomHUDCore)
    fileprivate static var WisdomLoadingStyle: WisdomLoadingStyle = .rotate

    fileprivate static var WisdomProgreStyle: WisdomProgreStyle = .circle

    fileprivate static var WisdomSceneBarStyle: WisdomSceneBarStyle = .dark
    
    fileprivate(set) static var WisdomSceneBarCustomColor: NSColor?//自定义文字小框背景色

    fileprivate static var WisdomColorThemeStyle: WisdomColorThemeStyle = .light

    fileprivate(set) static var WisdomTextMaxLineStyle: WisdomTextMaxLineStyle = .three

    fileprivate static var WisdomDisplayDelays: TimeInterval = 2.2

    fileprivate static var WisdomCoverBackgColor = NSColor(white: 0, alpha: 0.35)

    fileprivate(set) static var WisdomTextSizeStyle: WisdomTextSizeStyle = .minPro

    fileprivate static let WisdomHUDCoverTag = 221010

    nonisolated static func getWisdomHUD_Focusing() -> String { return "WisdomHUD_Focusing" }

    // MARK: 内部 panel 容器 — 一个用于普通 HUD,一个用于 Action(对应 iOS 的 tag>>1)
    fileprivate static var huudPanel: NSPanel?
    fileprivate static var actionPanel: NSPanel?
    fileprivate static var hostObservers: [NSObjectProtocol] = []
    fileprivate static weak var hostWindow: NSWindow?

    // 活动 cover 弱引用表 — 支撑 inSupView 任意挂载场景下的 dismiss 查找
    // iOS 通过 viewWithTag 走 UIWindow 子树;macOS 这里用弱表,避免遍历任意视图层级
    fileprivate static let activeCovers = NSHashTable<WisdomHUDMacCoverView>.weakObjects()
}


// MARK: - Settingable
extension WisdomHUDMacCore: WisdomHUDMacSettingable {

    static func setLoadingStyle(loadingStyle: WisdomLoadingStyle) {
        WisdomLoadingStyle = loadingStyle
    }

    static func setProgressStyle(progreStyle: WisdomProgreStyle) {
        WisdomProgreStyle = progreStyle
    }

    static func setSceneBarStyle(sceneBarStyle: WisdomSceneBarStyle) {
        WisdomSceneBarStyle = sceneBarStyle
    }
    
    static func setSceneBarCustomColor(color: NSColor?) {
        Self.WisdomSceneBarCustomColor = color
    }

    static func setTextMaxLines(maxLine: WisdomTextMaxLineStyle) {
        WisdomTextMaxLineStyle = maxLine
    }

    static func setDisplayDelay(delayTime: CGFloat) {
        WisdomDisplayDelays = TimeInterval(delayTime)
    }

    static func setCoverBackgColor(backgColor: NSColor) {
        WisdomCoverBackgColor = backgColor
    }

    static func setTextSizeStyle(textSizeStyle: WisdomTextSizeStyle) {
        WisdomTextSizeStyle = textSizeStyle
    }
}


// MARK: - Globalable
extension WisdomHUDMacCore: WisdomHUDMacGlobalable {

    static func dismiss() {
        if Thread.isMainThread {
            removeHUD()
        } else {
            DispatchQueue.main.async { removeHUD() }
        }
        
        func removeHUD() {
            // 同时清理 panel-mode 和 inSupView-mode 下挂载的所有 HUD cover
            for cover in activeCovers.allObjects where cover.tag == WisdomHUDCoverTag {
                cover.sceneView?.setDismissImage()
                cover.removeFromSuperview()
                activeCovers.remove(cover)
            }
            collapseEmptyPanel(huudPanel)
        }
    }

    static func dismissAction() {
        if Thread.isMainThread {
            removeAction()
        } else {
            DispatchQueue.main.async { removeAction() }
        }
        
        func removeAction() {
            for cover in activeCovers.allObjects where cover.tag == WisdomHUDCoverTag >> 1 {
                cover.removeFromSuperview()
                activeCovers.remove(cover)
            }
            collapseEmptyPanel(actionPanel)
        }
    }

    fileprivate static func collapseEmptyPanel(_ panel: NSPanel?) {
        guard let p = panel, let cv = p.contentView else { return }
        if !cv.subviews.contains(where: { $0 is WisdomHUDMacCoverView }) {
            hidePanel(p)
        }
    }

    fileprivate static func registerActiveCover(_ cover: WisdomHUDMacCoverView) {
        activeCovers.add(cover)
    }

    // 解析 cover 应当挂载到的根容器:
    //  - inSupView 不为空 → 直接使用(对齐 iOS 把 cover 挂到任意 UIView 的行为)
    //  - inSupView 为空 → 使用对应的 NSPanel.contentView
    
    fileprivate static func resolveRoot(inSupView: NSView?, isAction: Bool) -> NSView? {
        if let sup = inSupView { return sup }
        let panel = isAction ? ensureActionPanel() : ensureHUDPanel()
        return panel?.contentView
    }

    static func getScreenWindow() -> NSWindow? {
        if let key = NSApp.keyWindow, key !== huudPanel, key !== actionPanel { return key }
        if let main = NSApp.mainWindow, main !== huudPanel, main !== actionPanel { return main }
        return NSApp.windows.first { $0.isVisible && $0 !== huudPanel && $0 !== actionPanel }
    }

    // macOS 没有 iPhone 那种"小屏"概念，这里返回 true 以满足 protocol。
    static func isSmallScreen() -> Bool {
        return true
    }

    fileprivate static func hidePanel(_ p: NSPanel) {
        p.orderOut(nil)
    }

    fileprivate static func ensureHUDPanel() -> NSPanel? {
        return ensurePanel(slot: \.huudPanel, ordered: .above)
    }

    fileprivate static func ensureActionPanel() -> NSPanel? {
        return ensurePanel(slot: \.actionPanel, ordered: .above)
    }

    private static func ensurePanel(slot: WritableKeyPath<WisdomHUDMacCore.Type, NSPanel?>, ordered: NSWindow.OrderingMode) -> NSPanel? {
        guard let host = getScreenWindow() else { return nil }
        var meta = WisdomHUDMacCore.self
        if let existing = meta[keyPath: slot] {
            if existing.parent !== host {
                existing.parent?.removeChildWindow(existing)
                host.addChildWindow(existing, ordered: ordered)
            }
            existing.setFrame(host.frame, display: false)
            attachHostObservers(host: host)
            return existing
        }
        let p = NSPanel(contentRect: host.frame,
                        styleMask: [.borderless, .nonactivatingPanel],
                        backing: .buffered, defer: false)
        p.isFloatingPanel = false
        p.hidesOnDeactivate = true
        p.hasShadow = false
        p.isOpaque = false
        p.backgroundColor = .clear
        p.ignoresMouseEvents = false
        p.collectionBehavior = [.fullScreenAuxiliary, .ignoresCycle]
        p.contentView = NSView(frame: .zero)
        meta[keyPath: slot] = p
        host.addChildWindow(p, ordered: ordered)
        attachHostObservers(host: host)
        p.orderFrontRegardless()
        return p
    }

    private static func attachHostObservers(host: NSWindow) {
        guard host !== hostWindow else { return }
        hostObservers.forEach { NotificationCenter.default.removeObserver($0) }
        hostObservers.removeAll()
        hostWindow = host
        let names: [Notification.Name] = [NSWindow.didResizeNotification,
                                          NSWindow.didMoveNotification,
                                          NSWindow.didChangeScreenNotification]
        for n in names {
            let token = NotificationCenter.default.addObserver(forName: n, object: host, queue: .main) { [weak host] _ in
                // 闭包已在 .main OperationQueue 投递,这里再切到 @MainActor 上下文以满足 setFrame 的 actor 隔离要求。
                DispatchQueue.main.async { @MainActor in
                    guard let host = host else { return }
                    let frame = host.frame
                    if let p1 = huudPanel { p1.setFrame(frame, display: false) }
                    if let p2 = actionPanel { p2.setFrame(frame, display: false) }
                }
            }
            hostObservers.append(token)
        }
    }
}


// MARK: - 内部 SceneView 创建/复用(对齐 iOS getSceneView)
extension WisdomHUDMacCore {

    fileprivate static func getSceneView(hudStyle: WisdomHUDStyle,
                                         placeStyle: WisdomTextPlaceStyle? = nil,
                                         barStyle: WisdomSceneBarStyle,
                                         inSupView: NSView?) -> (WisdomHUDMacCoverView, WisdomHUDMacSceneView)? {
        // inSupView 不为空 → 挂到该 view 内(对齐 iOS);为空 → 走 NSPanel 全屏覆盖
        guard let rootVI = resolveRoot(inSupView: inSupView, isAction: false) else { return nil }

        // 已存在 cover?
        if let cover = rootVI.subviews.first(where: { ($0 as? WisdomHUDMacCoverView)?.tag == WisdomHUDCoverTag }) as? WisdomHUDMacCoverView {
            if cover.isSetting {
                cover.sceneView?.setDismissImage()
                cover.removeFromSuperview()
                return createCoverView(rootVI: rootVI)
            }
            if let scene = cover.sceneView, scene.hudStyle == hudStyle {
                scene.executeDelayClosure()
                scene.setStyleContent(barStyle: barStyle, placeStyle: placeStyle)
                cover.alphaValue = 1
                return (cover, scene)
            }
            cover.sceneView?.setDismissImage()
            cover.sceneView?.removeFromSuperview()
            cover.alphaValue = 1
            return (cover, createAndSetupSceneView(supView: cover, hudStyle: hudStyle, barStyle: barStyle, placeStyle: placeStyle))
        }
        return createCoverView(rootVI: rootVI)

        
        func createCoverView(rootVI: NSView) -> (WisdomHUDMacCoverView, WisdomHUDMacSceneView)? {
            let cover = WisdomHUDMacCoverView()
            cover.setWisdomTag(WisdomHUDCoverTag)
            cover.Wisdom_setBackgroundColor(WisdomCoverBackgColor)
            rootVI.addSubview(cover)
            rootVI.wisdom_addConstraint(with: cover,
                                        topView: rootVI, leftView: rootVI,
                                        bottomView: rootVI, rightView: rootVI,
                                        edgeInset: NSEdgeInsetsZero)
            registerActiveCover(cover)
            return (cover, createAndSetupSceneView(supView: cover, hudStyle: hudStyle, barStyle: barStyle, placeStyle: placeStyle))
        }

        func createAndSetupSceneView(supView: WisdomHUDMacCoverView, hudStyle: WisdomHUDStyle,
                                      barStyle: WisdomSceneBarStyle,
                                      placeStyle: WisdomTextPlaceStyle?) -> WisdomHUDMacSceneView {
            let scene = WisdomHUDMacSceneView(hudStyle: hudStyle, barStyle: barStyle, placeStyle: placeStyle)
            supView.sceneView = scene
            supView.addSubview(scene)
            if hudStyle == .text {
                switch placeStyle {
                case .center:
                    supView.wisdom_addConstraint(toCenterX: scene, toCenterY: scene)
                case .bottom:
                    supView.layoutSubtreeIfNeeded()
                    supView.wisdom_addConstraint(toCenterX: scene, toCenterY: nil)
                    let off = NSLayoutConstraint(item: scene, attribute: .bottom, relatedBy: .equal,
                                                 toItem: supView, attribute: .bottom,
                                                 multiplier: 1.0, constant: -supView.frame.height / 10.5)
                    off.identifier = WisdomHUDMacCore.getWisdomHUD_Focusing()
                    supView.addConstraint(off)
                default: break
                }
            } else {
                supView.wisdom_addConstraint(toCenterX: scene, toCenterY: scene)
            }
            return scene
        }
    }

    fileprivate static func setupActionView(inSupView: NSView?, actionView: WisdomHUDMacActionThemeView) -> WisdomHUDMacCoverView {
        // inSupView 不为空 → 挂到该 view 内(对齐 iOS);为空 → 走 actionPanel 全屏覆盖
        guard let rootVI = resolveRoot(inSupView: inSupView, isAction: true) else {
            return WisdomHUDMacCoverView()
        }
        if let cover = rootVI.subviews.first(where: { ($0 as? WisdomHUDMacCoverView)?.tag == WisdomHUDCoverTag >> 1 }) as? WisdomHUDMacCoverView {
            cover.actionView?.removeFromSuperview()
            cover.addSubview(actionView)
            cover.wisdom_addConstraint(toCenterX: actionView, toCenterY: actionView)
            actionView.wisdom_addConstraint(width: 310, height: -1)
            return cover
        }
        let cover = WisdomHUDMacCoverView()
        cover.setWisdomTag(WisdomHUDCoverTag >> 1)
        cover.Wisdom_setBackgroundColor(WisdomCoverBackgColor)
        rootVI.addSubview(cover)
        rootVI.wisdom_addConstraint(with: cover,
                                    topView: rootVI, leftView: rootVI,
                                    bottomView: rootVI, rightView: rootVI,
                                    edgeInset: NSEdgeInsetsZero)
        cover.addSubview(actionView)
        cover.wisdom_addConstraint(toCenterX: actionView, toCenterY: actionView)
        actionView.wisdom_addConstraint(width: 310, height: -1)
        registerActiveCover(cover)
        return cover
    }
}


// MARK: - showLoading
extension WisdomHUDMacCore: WisdomHUDMacLoadingable {

    static func showLoading(text: String) -> WisdomHUDMacLoadingContextable {
        return showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, inSupView: NSView?) -> WisdomHUDMacLoadingContextable {
        return showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacLoadingContextable {
        return showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle) -> WisdomHUDMacLoadingContextable {
        return showLoading(text: text, loadingStyle: loadingStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacLoadingContextable {
        return showLoading(text: text, loadingStyle: loadingStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, inSupView: NSView?) -> WisdomHUDMacLoadingContextable {
        return showLoading(text: text, loadingStyle: loadingStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacLoadingContextable {
        return showLoading(text: text, loadingStyle: WisdomLoadingStyle, barStyle: barStyle, inSupView: inSupView)
    }
    
    static func showLoading(text: String, loadingStyle: WisdomLoadingStyle, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacLoadingContextable {
        let context = WisdomHUDMacLoadingContext()
        DispatchQueue.main.async {
            if let cv = getSceneView(hudStyle: .loading, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: cv.0)
                cv.1.setLoadingContent(text: text, loadingStyle: loadingStyle, timeout: context.timeout)
                replayBaseSetters(context: context, scene: cv.1)
            }
        }
        return context
    }
}


// MARK: - showProgress
extension WisdomHUDMacCore: WisdomHUDMacProgreable {

    static func showProgress(text: String) -> WisdomHUDMacProgreContextable {
        return showProgress(text: text, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, inSupView: NSView?) -> WisdomHUDMacProgreContextable {
        return showProgress(text: text, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showProgress(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacProgreContextable {
        return showProgress(text: text, progreStyle: WisdomProgreStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle) -> WisdomHUDMacProgreContextable {
        return showProgress(text: text, progreStyle: progreStyle, barStyle: WisdomSceneBarStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacProgreContextable {
        return showProgress(text: text, progreStyle: progreStyle, barStyle: barStyle, inSupView: nil)
    }
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle, inSupView: NSView?) -> WisdomHUDMacProgreContextable {
        return showProgress(text: text, progreStyle: progreStyle, barStyle: WisdomSceneBarStyle, inSupView: inSupView)
    }
    
    static func showProgress(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacProgreContextable {
        return showProgress(text: text, progreStyle: WisdomProgreStyle, barStyle: barStyle, inSupView: inSupView)
    }
    
    static func showProgress(text: String, progreStyle: WisdomProgreStyle, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacProgreContextable {
        let context = WisdomHUDMacProgreContext()
        DispatchQueue.main.async {
            if let cv = getSceneView(hudStyle: .progress, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: cv.0)
                cv.1.setProgressContent(text: text, progreStyle: progreStyle, timeout: context.timeout)
                replayBaseSetters(context: context, scene: cv.1)
                if let c = context.progreColor { _ = context.setProgreColor(color: c) }
                if let v = context.progreValue { _ = context.setProgreValue(value: v) }
                if let c = context.progreTextColor { _ = context.setProgreTextColor(color: c) }
                if let c = context.progreShadowColor { _ = context.setProgreShadowColor(color: c) }
            }
        }
        return context
    }
}


// MARK: - showSuccess / showError / showWarning
extension WisdomHUDMacCore: WisdomHUDMacSuccessable {

    static func showSuccess(text: String) -> WisdomHUDMacContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacContextable {
        return showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showSuccess(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showSuccess(text: String, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showSuccess(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showSuccess(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showSuccess(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showState(.succes, text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


extension WisdomHUDMacCore: WisdomHUDMacErrorable {

    static func showError(text: String) -> WisdomHUDMacContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacContextable {
        return showError(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showError(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showError(text: String, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showError(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showError(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showError(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showState(.error, text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


extension WisdomHUDMacCore: WisdomHUDMacWarningable {

    static func showWarning(text: String) -> WisdomHUDMacContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacContextable {
        return showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showWarning(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showWarning(text: String, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showWarning(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showWarning(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showWarning(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showState(.warning, text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


// MARK: - showText
extension WisdomHUDMacCore: WisdomHUDMacTextCenterable {

    static func showTextCenter(text: String) -> WisdomHUDMacContextable {
        return showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacContextable {
        return showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showTextCenter(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextCenter(text: String, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showTextCenter(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showTextCenter(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextCenter(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showText(place: .center, text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}

extension WisdomHUDMacCore: WisdomHUDMacTextBottomable {

    static func showTextBottom(text: String) -> WisdomHUDMacContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle) -> WisdomHUDMacContextable {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?) -> WisdomHUDMacContextable {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: inSupView, delays: WisdomDisplayDelays, delayClosure: nil)
    }
    
    static func showTextBottom(text: String, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showTextBottom(text: text, barStyle: WisdomSceneBarStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showTextBottom(text: text, barStyle: barStyle, inSupView: nil, delays: delays, delayClosure: delayClosure)
    }
    
    static func showTextBottom(text: String, barStyle: WisdomSceneBarStyle, inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        return showText(place: .bottom, text: text, barStyle: barStyle, inSupView: inSupView, delays: delays, delayClosure: delayClosure)
    }
}


// MARK: - showAction
extension WisdomHUDMacCore: WisdomHUDMacActionable {

    static func showAction(title: String, text: String, leftAction: String?, rightAction: String, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) -> WisdomHUDMacActionContextable {
        return showAction(title: title, text: text, label: nil, leftAction: leftAction, rightAction: rightAction,
                          themeStyle: WisdomColorThemeStyle, inSupView: nil, actionClosure: actionClosure)
    }
    
    static func showAction(title: String, text: String, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) -> WisdomHUDMacActionContextable {
        return showAction(title: title, text: text, label: nil, leftAction: leftAction, rightAction: rightAction,
                          themeStyle: themeStyle, inSupView: nil, actionClosure: actionClosure)
    }
    
    static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) -> WisdomHUDMacActionContextable {
        return showAction(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction,
                          themeStyle: themeStyle, inSupView: nil, actionClosure: actionClosure)
    }
    
    static func showAction(title: String, text: String, label: String?, leftAction: String?, rightAction: String, themeStyle: WisdomColorThemeStyle, inSupView: NSView?, actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) -> WisdomHUDMacActionContextable {
        let context = WisdomHUDMacActionContext()
        DispatchQueue.main.async {
            let actionView = WisdomHUDMacActionThemeView(title: title, text: text, label: label,
                                                          leftAction: leftAction, rightAction: rightAction,
                                                          actionClosure: actionClosure)
            let cover = setupActionView(inSupView: inSupView, actionView: actionView)
            cover.actionView = actionView
            actionView.setThemeStyle(themeStyle: themeStyle)
            context.setCoverView(coverView: cover)
            // 回放
            if let l = context.leftAction { _ = context.setLeftAction(textColor: l.TextColor, textFont: l.TextFont) }
            if let r = context.rightAction { _ = context.setRightAction(textColor: r.TextColor, textFont: r.TextFont) }
            if let c = context.textColor { _ = context.setTextColor(color: c) }
            if let f = context.textFont { _ = context.setTextFont(font: f) }
            if let a = context.textAlignment { _ = context.setTextAlignment(alignment: a) }
            if let c = context.labelColor { _ = context.setLabelColor(color: c) }
            if let f = context.labelFont { _ = context.setLabelFont(font: f) }
        }
        return context
    }
}


// MARK: - Log API
// WisdomHUDMacLogView 整体 @MainActor 隔离,转发方法必须在 main actor 上下文调用。
@MainActor
extension WisdomHUDMacCore {

    static func openLog() {
        WisdomHUDMacLogView.openLog()
    }

    static func showLog(text: String) {
        WisdomHUDMacLogView.setLog(text: text)
    }

    static func showLogSuccess(text: String) {
        WisdomHUDMacLogView.setLog(text: "✅" + text + "✅")
    }

    static func showLogWarning(text: String) {
        WisdomHUDMacLogView.setLog(text: "⚠️" + text + "⚠️")
    }

    static func showLogError(text: String) {
        WisdomHUDMacLogView.setLog(text: "❌" + text + "❌")
    }

    static func showLogLabel(text: String) {
        WisdomHUDMacLogView.setLog(text: "🔥" + text + "🔥")
    }
}


// MARK: - 私有辅助:state HUD / text HUD / 链式 setter 回放
extension WisdomHUDMacCore {

    fileprivate static func showState(_ style: WisdomHUDStyle, text: String, barStyle: WisdomSceneBarStyle,
                                       inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        let context = WisdomHUDMacContext()
        DispatchQueue.main.async {
            if let cv = getSceneView(hudStyle: style, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: cv.0)
                switch style {
                case .succes:  cv.1.setSuccessContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                case .error:   cv.1.setErrorContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                case .warning: cv.1.setWarningContent(text: text, animat: false, delays: delays, delayClosure: delayClosure)
                default: break
                }
                if context.focusing { _ = context.setFocusing() }
                replayBaseSetters(context: context, scene: cv.1)
            }
        }
        return context
    }

    fileprivate static func showText(place: WisdomTextPlaceStyle, text: String, barStyle: WisdomSceneBarStyle,
                                      inSupView: NSView?, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?) -> WisdomHUDMacContextable {
        let context = WisdomHUDMacContext()
        DispatchQueue.main.async {
            if let cv = getSceneView(hudStyle: .text, placeStyle: place, barStyle: barStyle, inSupView: inSupView) {
                context.setCoverView(coverView: cv.0)
                cv.1.setTextContent(text: text, delays: delays, delayClosure: delayClosure)
                if context.focusing { _ = context.setFocusing() }
                if let c = context.textColor { _ = context.setTextColor(color: c) }
                if let f = context.textFont { _ = context.setTextFont(font: f) }
                if let t = context.updateText { _ = context.setUpdateText(text: t) }
            }
        }
        return context
    }

    fileprivate static func replayBaseSetters(context: WisdomHUDMacBaseContext, scene: WisdomHUDMacSceneView) {
        if let c = context.textColor { _ = context.setTextColor(color: c) }
        if let f = context.textFont { _ = context.setTextFont(font: f) }
        if let t = context.updateText { _ = context.setUpdateText(text: t) }
        if let v = context.animationVI { _ = context.setAnimation(view: v) }
    }
}

#endif
