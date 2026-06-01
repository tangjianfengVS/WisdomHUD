//
//  Log_macOS.swift
//  WisdomHUD
//
//  日志查看浮窗。AppKit 版,iOS Log.swift 对应。
//  iOS 是把日志视图挂在 App 窗口上、靠 4 方向停靠成边缘小药丸来"收起";
//  macOS 是独立的浮动 NSPanel,可原生拖拽/缩放,因此把 iOS 的 9 个按钮按 macOS 习惯重排为:
//    清空 / 顶部 / 底部 / 透明 / 大小 / 停靠 / 关闭
//  其中"停靠"循环把面板移动到屏幕 左→右→下 边缘并最终还原(对应 iOS 的 left/right/under + hang)。
//  正文 cell 套用 iOS 的 lineSpacing 富文本排版。
//

#if os(macOS)
import AppKit


// MARK: - 内部 store(只在 main actor 访问)

@MainActor
private struct WisdomMacLogStore {
    static var view: WisdomHUDMacLogView?
    static var list: [String] = [" [WisdomHUD] 日志已开启"]
    static var isOpen = false
    static var panel: NSPanel?
}


@MainActor
final class WisdomHUDMacLogView: NSView {

    // 正文排版常量(对齐 iOS WisdomHUDLogCell)
    fileprivate static let logFontSize: CGFloat = 13.7
    fileprivate static let logLineSpacing: CGFloat = 5.0
    fileprivate static let cellInset: CGFloat = 5.0

    fileprivate let scrollView = NSScrollView()
    fileprivate let tableView = NSTableView()
    private let textColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("WisdomLogText"))

    // 状态
    private enum DockState { case none, left, right, bottom }
    private var dockState: DockState = .none
    private var savedFrame: NSRect?
    private var bgDimmed = false
    private var expandedSize = false

    private lazy var clearBtn   = makeButton("清空", #selector(clickClear))
    private lazy var topBtn     = makeButton("顶部", #selector(clickTop))
    private lazy var bottomBtn  = makeButton("底部", #selector(clickBottom))
    private lazy var bgColorBtn = makeButton("透明", #selector(clickBgColor))
    private lazy var sizeBtn    = makeButton("大小", #selector(clickSize))
    private lazy var dockBtn    = makeButton("停靠", #selector(clickDock))
    private lazy var closeBtn   = makeButton("关闭", #selector(clickClose))

    private func makeButton(_ title: String, _ action: Selector) -> NSButton {
        let b = NSButton(title: title, target: self, action: action)
        b.bezelStyle = .rounded
        b.controlSize = .small
        b.font = NSFont.systemFont(ofSize: 11)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }

    init() {
        super.init(frame: NSRect(x: 0, y: 0, width: 420, height: 360))
        wantsLayer = true
        layer?.backgroundColor = NSColor(white: 0, alpha: 0.85).cgColor
        layer?.cornerRadius = 8

        textColumn.width = 400
        textColumn.title = ""
        tableView.headerView = nil
        tableView.backgroundColor = .clear
        tableView.usesAlternatingRowBackgroundColors = false
        tableView.gridStyleMask = []
        tableView.rowHeight = 22
        tableView.selectionHighlightStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addTableColumn(textColumn)

        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        let bar = NSStackView(views: [clearBtn, topBtn, bottomBtn, bgColorBtn, sizeBtn, dockBtn, closeBtn])
        bar.orientation = .horizontal
        bar.distribution = .fillEqually
        bar.spacing = 4
        bar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bar)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: -6),

            bar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            bar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bar.heightAnchor.constraint(equalToConstant: 22),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    fileprivate func reload() {
        tableView.reloadData()
        scrollToBottom()
    }

    private func scrollToBottom() {
        if WisdomMacLogStore.list.count > 0 {
            tableView.scrollRowToVisible(WisdomMacLogStore.list.count - 1)
        }
    }

    // MARK: 正文富文本(对齐 iOS lineSpacing 排版)

    fileprivate static func logAttributes() -> [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = logLineSpacing
        style.lineBreakMode = .byWordWrapping
        return [.font: NSFont.systemFont(ofSize: logFontSize, weight: .regular),
                .foregroundColor: NSColor.white,
                .paragraphStyle: style]
    }

    // MARK: 按钮事件

    @objc private func clickClear() {
        WisdomMacLogStore.list = [" [WisdomHUD] 日志已开启(历史日志已清空)"]
        reload()
    }

    @objc private func clickTop() {
        tableView.scrollRowToVisible(0)
    }

    @objc private func clickBottom() {
        scrollToBottom()
    }

    @objc private func clickBgColor() {
        bgDimmed.toggle()
        layer?.backgroundColor = NSColor(white: 0, alpha: bgDimmed ? 0.45 : 0.85).cgColor
    }

    @objc private func clickSize() {
        guard let panel = WisdomMacLogStore.panel,
              let screen = panel.screen ?? NSScreen.main else {
            return
        }
        expandedSize.toggle()
        let vf = screen.visibleFrame
        var f = panel.frame
        let top = f.maxY
        f.size.height = expandedSize ? vf.height * 0.9 : vf.height * 0.45
        f.origin.y = top - f.size.height   // 顶边保持不动
        panel.setFrame(f, display: true, animate: true)
    }

    // 停靠循环:无 → 左边缘 → 右边缘 → 下边缘 → 还原(对应 iOS left/right/under + hang)
    @objc private func clickDock() {
        guard let panel = WisdomMacLogStore.panel,
              let screen = panel.screen ?? NSScreen.main else {
            return
        }
        let vf = screen.visibleFrame
        let strip: CGFloat = 140
        switch dockState {
        case .none:
            savedFrame = panel.frame
            dockState = .left
            panel.setFrame(NSRect(x: vf.minX, y: vf.minY, width: strip, height: vf.height), display: true, animate: true)
        case .left:
            dockState = .right
            panel.setFrame(NSRect(x: vf.maxX - strip, y: vf.minY, width: strip, height: vf.height), display: true, animate: true)
        case .right:
            dockState = .bottom
            panel.setFrame(NSRect(x: vf.minX, y: vf.minY, width: vf.width, height: strip), display: true, animate: true)
        case .bottom:
            dockState = .none
            if let f = savedFrame { panel.setFrame(f, display: true, animate: true) }
            savedFrame = nil
        }
    }

    @objc private func clickClose() {
        WisdomHUDMacLogView.closeLog()
    }
}


extension WisdomHUDMacLogView: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return WisdomMacLogStore.list.count
    }

    func tableView(_ tv: NSTableView, viewFor column: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier("WisdomLogCell")
        let cell = (tv.makeView(withIdentifier: id, owner: nil) as? NSTextField) ?? {
            let f = NSTextField(labelWithString: "")
            f.identifier = id
            f.backgroundColor = .clear
            f.isBordered = false
            f.drawsBackground = false
            f.lineBreakMode = .byWordWrapping
            f.maximumNumberOfLines = 0
            return f
        }()
        let text = row < WisdomMacLogStore.list.count ? WisdomMacLogStore.list[row] : " "
        cell.attributedStringValue = NSAttributedString(string: text.isEmpty ? " " : text,
                                                        attributes: Self.logAttributes())
        return cell
    }

    func tableView(_ tv: NSTableView, heightOfRow row: Int) -> CGFloat {
        let base = Self.cellInset * 2
        guard row < WisdomMacLogStore.list.count else {
            return 22
        }
        let s = WisdomMacLogStore.list[row]
        if s.isEmpty {
            return 22
        }
        let width = max(textColumn.width, tv.bounds.width - 8)
        let bounding = (s as NSString).boundingRect(
            with: NSSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: Self.logAttributes())
        return max(22, ceil(bounding.height) + base)
    }
}


// MARK: - 静态 API:openLog / setLog / closeLog

extension WisdomHUDMacLogView {

    static func openLog() {
#if DEBUG
        if Thread.isMainThread {
            doOpen()
        } else {
            DispatchQueue.main.async { doOpen() }
        }
        @MainActor
        func doOpen() {
            guard !WisdomMacLogStore.isOpen else {
                return
            }
            WisdomMacLogStore.isOpen = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { @MainActor in
                presentLogPanel()
            }
        }
#endif
    }

    static func setLog(text: String) {
#if DEBUG
        if Thread.isMainThread {
            doSet()
        } else {
            DispatchQueue.main.async { doSet() }
        }
        @MainActor
        func doSet() {
            guard WisdomMacLogStore.isOpen else {
                return
            }
            // 宿主窗口被销毁后,补建面板(对应 iOS checkWisdomLogsViewPoint 的失活重建)
            if let panel = WisdomMacLogStore.panel, !panel.isVisible {
                WisdomMacLogStore.panel = nil
                WisdomMacLogStore.view = nil
            }
            WisdomMacLogStore.list.append(text)
            WisdomMacLogStore.view?.reload()
            if WisdomMacLogStore.view == nil {
                presentLogPanel()
            }
        }
#endif
    }

    @MainActor
    fileprivate static func closeLog() {
        WisdomMacLogStore.panel?.orderOut(nil)
        WisdomMacLogStore.panel = nil
        WisdomMacLogStore.view = nil
        WisdomMacLogStore.isOpen = false
    }

    @MainActor
    private static func presentLogPanel() {
        guard WisdomMacLogStore.view == nil else {
            return
        }
        let host = WisdomHUDMacCore.getScreenWindow()
        let originRect: NSRect
        if let h = host {
            originRect = NSRect(x: h.frame.minX + 20, y: h.frame.maxY - 20 - 360, width: 420, height: 360)
        } else {
            originRect = NSRect(x: 60, y: 60, width: 420, height: 360)
        }
        let panel = NSPanel(contentRect: originRect,
                            styleMask: [.titled, .closable, .resizable, .nonactivatingPanel, .utilityWindow],
                            backing: .buffered,
                            defer: false)
        panel.title = "WisdomHUD Log"
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.collectionBehavior = [.fullScreenAuxiliary]
        panel.minSize = NSSize(width: 320, height: 120)

        let v = WisdomHUDMacLogView()
        v.translatesAutoresizingMaskIntoConstraints = false
        let content = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        panel.contentView = content
        content.addSubview(v)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: content.topAnchor),
            v.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: content.bottomAnchor),
        ])

        WisdomMacLogStore.panel = panel
        WisdomMacLogStore.view = v
        v.reload()
        panel.orderFrontRegardless()
    }
}

#endif
