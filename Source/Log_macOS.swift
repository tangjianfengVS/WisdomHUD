//
//  Log_macOS.swift
//  WisdomHUD
//
//  日志查看浮窗。AppKit 版,iOS Log.swift 对应。
//  简化:9 个控制按钮(close/clear/size/bgcolor + 4 方向移动 + 折叠)替换为 macOS 习惯
//        3 个按钮:Clear / 折叠 / 关闭。窗口拖拽走 NSPanel 标题栏(无标题栏则按 contentView 拖拽)。
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

    fileprivate let scrollView = NSScrollView()
    fileprivate let tableView = NSTableView()
    private let textColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("WisdomLogText"))
    private var collapsed = false

    private lazy var clearBtn: NSButton = {
        let b = NSButton(title: "清空", target: self, action: #selector(clickClear))
        b.bezelStyle = .rounded
        return b
    }()

    private lazy var collapseBtn: NSButton = {
        let b = NSButton(title: "折叠", target: self, action: #selector(clickCollapse))
        b.bezelStyle = .rounded
        return b
    }()

    private lazy var closeBtn: NSButton = {
        let b = NSButton(title: "关闭", target: self, action: #selector(clickClose))
        b.bezelStyle = .rounded
        return b
    }()

    init() {
        super.init(frame: NSRect(x: 0, y: 0, width: 360, height: 320))
        wantsLayer = true
        layer?.backgroundColor = NSColor(white: 0, alpha: 0.85).cgColor
        layer?.cornerRadius = 8

        textColumn.width = 340
        textColumn.title = ""
        tableView.headerView = nil
        tableView.backgroundColor = .clear
        tableView.usesAlternatingRowBackgroundColors = false
        tableView.gridStyleMask = []
        tableView.rowHeight = 22
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addTableColumn(textColumn)

        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        for b in [clearBtn, collapseBtn, closeBtn] {
            b.translatesAutoresizingMaskIntoConstraints = false
            addSubview(b)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -42),

            closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            closeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            collapseBtn.trailingAnchor.constraint(equalTo: closeBtn.leadingAnchor, constant: -6),
            collapseBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            clearBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            clearBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    fileprivate func reload() {
        tableView.reloadData()
        if WisdomMacLogStore.list.count > 0 {
            tableView.scrollRowToVisible(WisdomMacLogStore.list.count - 1)
        }
    }

    @objc private func clickClear() {
        WisdomMacLogStore.list = [" [WisdomHUD] 日志已开启(历史日志已清空)"]
        reload()
    }

    @objc private func clickCollapse() {
        collapsed.toggle()
        guard let panel = WisdomMacLogStore.panel else { return }
        var f = panel.frame
        if collapsed {
            f.size.height = 60
        } else {
            f.size.height = 320
        }
        panel.setFrame(f, display: true, animate: true)
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
            f.font = NSFont.systemFont(ofSize: 12)
            f.textColor = .white
            f.backgroundColor = .clear
            f.isBordered = false
            f.drawsBackground = false
            f.lineBreakMode = .byWordWrapping
            f.maximumNumberOfLines = 0
            return f
        }()
        if row < WisdomMacLogStore.list.count {
            cell.stringValue = WisdomMacLogStore.list[row]
        } else {
            cell.stringValue = " "
        }
        return cell
    }

    func tableView(_ tv: NSTableView, heightOfRow row: Int) -> CGFloat {
        guard row < WisdomMacLogStore.list.count else { return 22 }
        let s = WisdomMacLogStore.list[row]
        if s.isEmpty { return 22 }
        let attr: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: 12)]
        let bounding = (s as NSString).boundingRect(with: NSSize(width: 340, height: CGFloat.greatestFiniteMagnitude),
                                                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                    attributes: attr)
        return max(22, bounding.height + 8)
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
            guard !WisdomMacLogStore.isOpen else { return }
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
            guard WisdomMacLogStore.isOpen else { return }
            WisdomMacLogStore.list.append(text)
            WisdomMacLogStore.view?.reload()
            // 第一次 setLog 时如果 panel 还没建,补建
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
        guard WisdomMacLogStore.view == nil else { return }
        let host = WisdomHUDMacCore.getScreenWindow()
        let originRect: NSRect
        if let h = host {
            // 默认在 host 左上角下方
            originRect = NSRect(x: h.frame.minX + 20, y: h.frame.maxY - 20 - 320, width: 360, height: 320)
        } else {
            originRect = NSRect(x: 60, y: 60, width: 360, height: 320)
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
