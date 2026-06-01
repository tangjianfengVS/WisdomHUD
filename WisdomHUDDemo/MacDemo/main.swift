//
//  main.swift
//  WisdomHUDMacDemo
//
//  WisdomHUD macOS 演示 App,结构与 iOS 端(WisdomHUDHomeVC + WisdomHUDHomeView)保持一致:
//   - 一个分组列表,分区 = WisdomHUDStyle.allCases(succes/error/warning/loading/progress/text/action)
//   - 每行:左侧实时小图标(对应的 WisdomHUDMac* 视图) + 居中样式名 + 右侧 "›"
//   - 顶部 BarStyle 选择器(dark/light/hide),选中态粉色高亮
//   - 点击某行触发与 iOS 相同的 WisdomHUD 调用(含链式 setFocusing/setTextColor/setTimeout 等)
//
//  本 Demo 的 Xcode target 直接编译 Source/*.swift(同一 module),故无需 import WisdomHUD。
//

#if os(macOS)
import AppKit

// 与 iOS demo 的全局 sceneBarStyle 对齐
@MainActor var sceneBarStyle: WisdomSceneBarStyle = .dark


// MARK: - 枚举显示名(@objc/NSInteger 枚举字符串插值会得到 "Xxx(rawValue:0)",故按 iOS 做法显式映射)

func name(_ s: WisdomSceneBarStyle) -> String {
    switch s { case .dark: return "dark"; case .light: return "light"; case .hide: return "hide" }
}
func name(_ s: WisdomLoadingStyle) -> String {
    switch s {
    case .system: return "system"; case .rotate: return "rotate"; case .progressArc: return "progressArc"
    case .tadpoleArc: return "tadpoleArc"; case .chaseBall: return "chaseBall"
    case .pulseBall: return "pulseBall"; case .pulseShape: return "pulseShape"
    }
}
func name(_ s: WisdomProgreStyle) -> String {
    switch s { case .circle: return "circle"; case .linear: return "linear"; case .water: return "water" }
}
func name(_ s: WisdomTextPlaceStyle) -> String {
    switch s { case .center: return "center"; case .bottom: return "bottom" }
}
func name(_ s: WisdomColorThemeStyle) -> String {
    switch s { case .light: return "light"; case .dark: return "dark" }
}


// MARK: - 行模型(分区头 / 内容行)

enum DemoRow {
    case header(String)
    case item(hudStyle: WisdomHUDStyle,
              loading: WisdomLoadingStyle?,
              progre: WisdomProgreStyle?,
              place: WisdomTextPlaceStyle?,
              theme: WisdomColorThemeStyle?,
              title: String)
}

@MainActor
func buildRows() -> [DemoRow] {
    var rows: [DemoRow] = []
    for hud in WisdomHUDStyle.allCases {
        rows.append(.header("\(hud)"))
        switch hud {
        case .succes, .error, .warning:
            rows.append(.item(hudStyle: hud, loading: nil, progre: nil, place: nil, theme: nil, title: "\(hud)"))
        case .loading:
            for ls in WisdomLoadingStyle.allCases {
                rows.append(.item(hudStyle: hud, loading: ls, progre: nil, place: nil, theme: nil, title: "\(hud).\(name(ls))"))
            }
        case .progress:
            for ps in WisdomProgreStyle.allCases {
                rows.append(.item(hudStyle: hud, loading: nil, progre: ps, place: nil, theme: nil, title: "\(hud).\(name(ps))"))
            }
        case .text:
            for tp in WisdomTextPlaceStyle.allCases {
                rows.append(.item(hudStyle: hud, loading: nil, progre: nil, place: tp, theme: nil, title: "\(hud).\(name(tp))"))
            }
        case .action:
            for th in WisdomColorThemeStyle.allCases {
                rows.append(.item(hudStyle: hud, loading: nil, progre: nil, place: nil, theme: th, title: "\(hud).\(name(th))"))
            }
        }
    }
    return rows
}


// MARK: - 顶部 BarStyle 选择器(对齐 iOS WisdomBarStyleView)

@MainActor
final class BarStyleSelector: NSView {
    private let onChange: (WisdomSceneBarStyle) -> Void
    private var buttons: [NSButton] = []

    init(onChange: @escaping (WisdomSceneBarStyle) -> Void) {
        self.onChange = onChange
        super.init(frame: .zero)
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        for style in WisdomSceneBarStyle.allCases {
            let b = NSButton(title: ".\(name(style))", target: self, action: #selector(tap(_:)))
            b.tag = style.rawValue
            b.bezelStyle = .smallSquare
            b.isBordered = false
            b.wantsLayer = true
            b.font = NSFont.boldSystemFont(ofSize: 12)
            b.translatesAutoresizingMaskIntoConstraints = false
            b.widthAnchor.constraint(equalToConstant: 52).isActive = true
            b.heightAnchor.constraint(equalToConstant: 24).isActive = true
            stack.addArrangedSubview(b)
            buttons.append(b)
        }
        wantsLayer = true
        layer?.cornerRadius = 6
        layer?.masksToBounds = true
        layer?.borderWidth = 0.5
        layer?.borderColor = NSColor.separatorColor.cgColor
        refresh()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func refresh() {
        for b in buttons {
            let selected = b.tag == sceneBarStyle.rawValue
            b.layer?.backgroundColor = selected ? NSColor.systemPink.cgColor : NSColor.clear.cgColor
            b.attributedTitle = NSAttributedString(string: b.title, attributes: [
                .foregroundColor: selected ? NSColor.white : NSColor.secondaryLabelColor,
                .font: NSFont.boldSystemFont(ofSize: 12)
            ])
        }
    }

    @objc private func tap(_ sender: NSButton) {
        if let s = WisdomSceneBarStyle(rawValue: sender.tag) {
            sceneBarStyle = s
            refresh()
            onChange(s)
        }
    }
}


// MARK: - 主控制器

@MainActor
final class DemoController: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    private var rows: [DemoRow] = buildRows()
    private let tableView = NSTableView()
    private var progreTimer: Timer?

    func makeWindow() -> NSWindow {
        let win = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 720),
                           styleMask: [.titled, .closable, .miniaturizable, .resizable],
                           backing: .buffered, defer: false)
        win.title = "WisdomHUD"
        win.center()

        let content = NSView()
        win.contentView = content

        // 顶部栏:标题 + BarStyle 选择器(对齐 iOS 导航栏右侧)
        let titleLabel = NSTextField(labelWithString: "WisdomHUD")
        titleLabel.font = NSFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let selector = BarStyleSelector { [weak self] _ in self?.tableView.reloadData() }
        selector.translatesAutoresizingMaskIntoConstraints = false

        content.addSubview(titleLabel)
        content.addSubview(selector)

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("c"))
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)
        tableView.headerView = nil
        tableView.backgroundColor = .clear
        tableView.gridStyleMask = []
        tableView.selectionHighlightStyle = .none
        tableView.intercellSpacing = NSSize(width: 0, height: 6)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.target = self
        tableView.action = #selector(rowClicked)

        let scroll = NSScrollView()
        scroll.documentView = tableView
        scroll.hasVerticalScroller = true
        scroll.drawsBackground = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(scroll)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: content.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 16),

            selector.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            selector.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -16),

            scroll.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            scroll.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 15),
            scroll.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -15),
            scroll.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -10),
        ])
        return win
    }

    // MARK: NSTableView

    func numberOfRows(in tableView: NSTableView) -> Int { rows.count }

    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        return false   // 分区头用空白行实现,不走 group-row 样式(对齐 iOS 空白间隔)
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if case .header = rows[row] { return 15 }   // 对齐 iOS:分区头为 15pt 空白间隔
        return 50
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if case .header = rows[row] { return false }
        return true
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        switch rows[row] {
        case .header:
            return NSView()   // 对齐 iOS:空白分区头
        case let .item(hud, loading, progre, place, _, title):
            return makeRowView(hud: hud, loading: loading, progre: progre, place: place, title: title)
        }
    }

    // 行视图:圆角卡片 + 左图标 + 居中标题 + 右 "›"(对齐 iOS WisdomCustomNextCell)
    private func makeRowView(hud: WisdomHUDStyle,
                             loading: WisdomLoadingStyle?,
                             progre: WisdomProgreStyle?,
                             place: WisdomTextPlaceStyle?,
                             title: String) -> NSView {
        let card = NSView()
        card.wantsLayer = true
        card.layer?.cornerRadius = 10
        card.layer?.masksToBounds = true

        let info = NSTextField(labelWithString: title)
        info.font = NSFont.boldSystemFont(ofSize: 15)
        info.translatesAutoresizingMaskIntoConstraints = false

        let chevron = NSTextField(labelWithString: "›")
        chevron.font = NSFont.systemFont(ofSize: 20)
        chevron.translatesAutoresizingMaskIntoConstraints = false

        switch sceneBarStyle {
        case .dark, .hide:
            card.layer?.backgroundColor = NSColor.black.cgColor
            info.textColor = .white
            chevron.textColor = NSColor(white: 0.6, alpha: 1)
        case .light:
            card.layer?.backgroundColor = NSColor.white.cgColor
            info.textColor = .black
            chevron.textColor = NSColor(white: 0.4, alpha: 1)
        }

        card.addSubview(info)
        card.addSubview(chevron)
        NSLayoutConstraint.activate([
            info.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            info.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            chevron.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
        ])

        // 左侧实时图标(与 iOS 相同:直接实例化对应视图)
        if let icon = makeIcon(hud: hud, loading: loading, progre: progre, place: place) {
            icon.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(icon)
            let size: CGFloat = progre != nil ? 35 : 24
            let left: CGFloat = progre != nil ? 30 : 35
            NSLayoutConstraint.activate([
                icon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: left),
                icon.centerYAnchor.constraint(equalTo: card.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: size),
                icon.heightAnchor.constraint(equalToConstant: size),
            ])
        }
        return card
    }

    private func makeIcon(hud: WisdomHUDStyle,
                          loading: WisdomLoadingStyle?,
                          progre: WisdomProgreStyle?,
                          place: WisdomTextPlaceStyle?) -> NSView? {
        switch hud {
        case .succes:
            let v = WisdomHUDMacSuccessView(size: 24, barStyle: sceneBarStyle); v.beginAnimation(isRepeat: false); return v
        case .error:
            let v = WisdomHUDMacErrorView(size: 24, barStyle: sceneBarStyle); v.beginAnimation(isRepeat: false); return v
        case .warning:
            let v = WisdomHUDMacWarningView(size: 24, barStyle: sceneBarStyle); v.beginAnimation(isRepeat: false); return v
        case .loading:
            switch loading {
            case .system:      return WisdomHUDMacIndicatorView(size: 24, barStyle: sceneBarStyle)
            case .rotate:      return WisdomHUDMacRotateView(size: 24, barStyle: sceneBarStyle)
            case .progressArc: return WisdomHUDMacProgressArcView(size: 24, barStyle: sceneBarStyle)
            case .tadpoleArc:  return WisdomHUDMacTadpoleArcView(size: 24, barStyle: sceneBarStyle)
            case .chaseBall:   return WisdomHUDMacChaseBallView(size: 24, barStyle: sceneBarStyle)
            case .pulseBall:   return WisdomHUDMacPulseBallView(size: 24, barStyle: sceneBarStyle)
            case .pulseShape:  return WisdomHUDMacPulseShapeView(size: 24, barStyle: sceneBarStyle)
            case .none:        return nil
            }
        case .progress:
            switch progre {
            case .circle:
                let v = WisdomHUDMacImageCircleView(size: 35, barStyle: sceneBarStyle)
                v.setProgreValue(value: 60); v.setProgreColor(color: .systemPink); v.setProgreTextColor(color: .systemPink); return v
            case .linear:
                let v = WisdomHUDMacImageLinearView(size: 35, barStyle: sceneBarStyle)
                v.setProgreValue(value: 60); v.setProgreColor(color: .systemPink); v.setProgreTextColor(color: .systemPink); return v
            case .water:
                let v = WisdomHUDMacImageWaterView(size: 35, barStyle: sceneBarStyle)
                v.setProgreValue(value: 60); v.setProgreColor(color: .systemPink); return v
            case .none: return nil
            }
        case .text, .action:
            return nil
        }
    }

    // MARK: 点击分发(对齐 iOS didSelectRowAt)

    @objc private func rowClicked() {
        let row = tableView.clickedRow
        guard row >= 0, row < rows.count else { return }
        guard case let .item(hud, loading, progre, place, theme, _) = rows[row] else { return }
        perform(hud: hud, loading: loading, progre: progre, place: place, theme: theme)
    }

    private func perform(hud: WisdomHUDStyle,
                         loading: WisdomLoadingStyle?,
                         progre: WisdomProgreStyle?,
                         place: WisdomTextPlaceStyle?,
                         theme: WisdomColorThemeStyle?) {
        switch hud {
        case .succes:
            WisdomHUD.showLogSuccess(text: "WisdomHUD.showSuccess('加载成功', delays: 3)")
            _ = WisdomHUD.showSuccess(text: "加载成功", barStyle: sceneBarStyle, delays: 3) { _ in }

        case .error:
            WisdomHUD.showLogError(text: "WisdomHUD.showError('加载失败', delays: 3)")
            _ = WisdomHUD.showError(text: "加载失败", barStyle: sceneBarStyle, delays: 3) { _ in }
                .setFocusing().setTextColor(color: .red).setTextFont(font: NSFont.boldSystemFont(ofSize: 14))

        case .warning:
            WisdomHUD.showLogWarning(text: "WisdomHUD.showWarning('加载警告', delays: 3)")
            _ = WisdomHUD.showWarning(text: "加载警告", barStyle: sceneBarStyle, delays: 3) { _ in }.setFocusing()

        case .loading:
            guard let ls = loading else { return }
            WisdomHUD.showLogSuccess(text: ".loading-\(ls)")
            _ = WisdomHUD.showLoading(text: "正在加载中", loadingStyle: ls, barStyle: sceneBarStyle)
                .setTimeout(time: 8) { _ in
                    _ = WisdomHUD.showTextBottom(text: "加载超时，稍后重试", barStyle: sceneBarStyle, delays: 5, delayClosure: nil).setFocusing()
                }

        case .text:
            WisdomHUD.showLog(text: "WisdomHUD.showText(...)")
            switch place {
            case .center:
                _ = WisdomHUD.showTextCenter(text: "inSupView 添加失败，请稍后重试", barStyle: sceneBarStyle, delays: 3) { _ in }
                    .setFocusing().setTextColor(color: .blue).setTextFont(font: NSFont.boldSystemFont(ofSize: 14))
            case .bottom:
                _ = WisdomHUD.showTextBottom(text: "inSupView 添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试,添加失败，请稍后重试",
                                             barStyle: sceneBarStyle, delays: 3) { _ in }.setFocusing()
            case .none: break
            }

        case .progress:
            guard let ps = progre else { return }
            progreTimer?.invalidate()
            let ctx = WisdomHUD.showProgress(text: "上传文件", progreStyle: ps, barStyle: sceneBarStyle).setProgreColor(color: .systemPink)
            var step: UInt = 0
            progreTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
                MainActor.assumeIsolated {
                    step += 1
                    _ = ctx.setProgreValue(value: step * 10)
                    if step >= 9 {
                        self.progreTimer?.invalidate()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { WisdomHUD.dismiss() }
                    }
                }
            }

        case .action:
            let theme = theme ?? .light
            let text1 = "`WisdomHUD` 是一款多种样式的 HUD 弹框指示器 SDK。`WisdomHUD` 由 Swift 编写,iOS / macOS 双平台支持。"
            let text2 = "`WisdomHUD` 是一款多种样式的 HUD 弹框指示器 SDK。支持 全局/单点 HUD 内部属性动态调整,支持视图聚焦显示设置。支持 超时/延迟 时间设置与结束事件回调。支持多种 Loading/Progress 加载样式,和 success/error/warning/text 提示样式。图标通过绘制实现,无资源文件依赖。API 调用方便/灵活,推荐使用。"
            _ = WisdomHUD.showAction(title: "WisdomHUD", text: text2, label: "WisdomHUD sdk",
                                     leftAction: "取消", rightAction: "确认", themeStyle: theme) { _, value in
                if value == .right {
                    _ = WisdomHUD.showAction(title: "WisdomHUD", text: text1, label: "WisdomHUD sdk",
                                             leftAction: nil, rightAction: "确认", themeStyle: theme) { _, _ in true }
                        .setRightAction(textColor: .systemPink, textFont: nil).setLeftAction(textColor: .gray, textFont: nil)
                        .setTextAlignment(alignment: .left).setTextColor(color: .orange).setTextFont(font: NSFont.boldSystemFont(ofSize: 13))
                }
                return true
            }.setRightAction(textColor: .systemPink, textFont: nil).setLeftAction(textColor: .gray, textFont: nil).setTextAlignment(alignment: .left)
        }
    }

    // 命令行 --demo <styleName> 自动触发(截图验证用,不影响 UI)
    func autoRun(_ name: String) {
        for r in rows {
            if case let .item(hud, loading, progre, place, theme, title) = r,
               title == name || "\(hud)" == name {
                perform(hud: hud, loading: loading, progre: progre, place: place, theme: theme)
                return
            }
        }
    }
}


@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let controller = DemoController()
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let win = controller.makeWindow()
        win.makeKeyAndOrderFront(nil)
        window = win
        NSApp.activate(ignoringOtherApps: true)

        let args = CommandLine.arguments
        if let idx = args.firstIndex(of: "--demo"), idx + 1 < args.count {
            let name = args[idx + 1]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                self?.controller.autoRun(name)
            }
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}

MainActor.assumeIsolated {
    let app = NSApplication.shared
    app.setActivationPolicy(.regular)
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}

#else
print("WisdomHUDMacDemo 仅支持 macOS。")
#endif
