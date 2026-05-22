//
//  Action_macOS.swift
//  WisdomHUD
//
//  对话框 HUD:title + text + (label) + leftBtn + rightBtn。AppKit 版,iOS Action.swift 对应。
//  尺寸:小屏 290 / 普通 310,与 iOS 一致(macOS 没小屏概念,固定 310)。
//

#if os(macOS)
import AppKit


extension WisdomColorThemeStyle {

    static func getColor(themeStyle: WisdomColorThemeStyle) -> (HUDColor: NSColor,
                                                                TitleColor: NSColor,
                                                                TextColor: NSColor,
                                                                TailColor: NSColor,
                                                                LayerColor: NSColor,
                                                                LineColor: NSColor) {
        var hudColor = NSColor.white
        var titleColor = NSColor.white
        var textColor = NSColor.white
        var tailColor = NSColor.white
        var layerColor = NSColor.white
        var lineColor = NSColor(white: 0.94, alpha: 1)
        switch themeStyle {
        case .light:
            titleColor = NSColor(white: 0.2, alpha: 1)
            textColor = NSColor(white: 0.2, alpha: 1)
            tailColor = NSColor(white: 0.2, alpha: 1)
            layerColor = .gray
        case .dark:
            hudColor = NSColor(white: 0, alpha: 0.9)
            titleColor = .wisdom_color(hex: "C0C0C0")
            textColor = .wisdom_color(hex: "C0C0C0")
            tailColor = .wisdom_color(hex: "C0C0C0")
            lineColor = NSColor(white: 0.18, alpha: 1)
        }
        return (hudColor, titleColor, textColor, tailColor, layerColor, lineColor)
    }
}


class WisdomHUDMacActionView: NSView {

    fileprivate let titleLabel: NSTextField = {
        let f = NSTextField(labelWithString: "")
        f.font = NSFont.boldSystemFont(ofSize: 14)
        f.textColor = .black
        f.alignment = .center
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    fileprivate let textLabel: NSTextField = {
        let f = NSTextField(labelWithString: "")
        f.font = NSFont.systemFont(ofSize: 13.5)
        f.textColor = .black
        f.alignment = .left
        f.lineBreakMode = .byWordWrapping
        f.maximumNumberOfLines = 0
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    fileprivate let titleLineVI: NSView = {
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor(white: 0.95, alpha: 1).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate let hitView: NSView = {
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor(white: 0.90, alpha: 1).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate let tailLabel: NSTextField = {
        let f = NSTextField(labelWithString: "")
        f.font = NSFont.systemFont(ofSize: 13)
        f.textColor = .black
        f.alignment = .left
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    fileprivate let acrossLineVI: NSView = {
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor(white: 0.95, alpha: 1).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate let betweenLineVI: NSView = {
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor(white: 0.95, alpha: 1).cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate lazy var leftBtn: NSButton = {
        let b = NSButton(title: "", target: self, action: #selector(clickLeftBtn(_:)))
        b.bezelStyle = .smallSquare
        b.isBordered = false
        b.font = NSFont.boldSystemFont(ofSize: 15)
        b.contentTintColor = .black
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    fileprivate lazy var rightBtn: NSButton = {
        let b = NSButton(title: "", target: self, action: #selector(clickRightBtn(_:)))
        b.bezelStyle = .smallSquare
        b.isBordered = false
        b.font = NSFont.boldSystemFont(ofSize: 15)
        b.contentTintColor = .black
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    fileprivate var hitBottomConstraint: NSLayoutConstraint?

    fileprivate var titleTopConstraint: NSLayoutConstraint?

    private let actionClosure: (String, WisdomActionValueStyle) -> (Bool)

    init(title: String, text: String, label: String?, leftAction: String?, rightAction: String,
         actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) {
        self.actionClosure = actionClosure
        super.init(frame: .zero)
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(titleLineVI)
        addSubview(textLabel)
        addSubview(acrossLineVI)
        addSubview(betweenLineVI)
        addSubview(hitView)
        addSubview(tailLabel)

        wisdom_addConstraint(with: titleLabel,
                             topView: self, leftView: self, bottomView: nil, rightView: self,
                             edgeInset: NSEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))

        wisdom_addConstraint(with: titleLineVI,
                             topView: self, leftView: self, bottomView: nil, rightView: self,
                             edgeInset: NSEdgeInsets(top: 38, left: 0, bottom: 0, right: 0))
        titleLineVI.wisdom_addConstraint(width: -1, height: 1)

        let titleConstraint = NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal,
                                                 toItem: titleLineVI, attribute: .bottom,
                                                 multiplier: 1.0, constant: 15)
        titleTopConstraint = titleConstraint
        addConstraint(titleConstraint)
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal,
                                         toItem: self, attribute: .left,
                                         multiplier: 1.0, constant: 18))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal,
                                         toItem: self, attribute: .right,
                                         multiplier: 1.0, constant: -18))

        wisdom_addConstraint(with: acrossLineVI,
                             topView: nil, leftView: self, bottomView: self, rightView: self,
                             edgeInset: NSEdgeInsets(top: 0, left: 0, bottom: -46, right: 0))
        acrossLineVI.wisdom_addConstraint(width: -1, height: 1)

        wisdom_addConstraint(with: betweenLineVI,
                             topView: acrossLineVI, leftView: nil, bottomView: self, rightView: nil,
                             edgeInset: NSEdgeInsets(top: 1, left: 0, bottom: 0, right: 0))
        wisdom_addConstraint(toCenterX: betweenLineVI, toCenterY: nil)
        betweenLineVI.wisdom_addConstraint(width: 1, height: -1)

        // hit dot
        hitView.wisdom_addConstraint(width: 7, height: 7)
        addConstraint(NSLayoutConstraint(item: hitView, attribute: .left, relatedBy: .equal,
                                         toItem: textLabel, attribute: .left,
                                         multiplier: 1.0, constant: 0))
        let hitConstraint = NSLayoutConstraint(item: hitView, attribute: .bottom, relatedBy: .equal,
                                               toItem: acrossLineVI, attribute: .bottom,
                                               multiplier: 1.0, constant: -20)
        hitBottomConstraint = hitConstraint
        addConstraint(hitConstraint)
        addConstraint(NSLayoutConstraint(item: hitView, attribute: .top, relatedBy: .equal,
                                         toItem: textLabel, attribute: .bottom,
                                         multiplier: 1.0, constant: 18))
        hitView.layer?.masksToBounds = true
        hitView.layer?.cornerRadius = 7 / 2

        addConstraint(NSLayoutConstraint(item: tailLabel, attribute: .left, relatedBy: .equal,
                                         toItem: hitView, attribute: .right,
                                         multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: tailLabel, attribute: .right, relatedBy: .equal,
                                         toItem: textLabel, attribute: .right,
                                         multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tailLabel, attribute: .centerY, relatedBy: .equal,
                                         toItem: hitView, attribute: .centerY,
                                         multiplier: 1.0, constant: 0))

        setactionList(leftAction: leftAction, rightAction: rightAction)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override var isFlipped: Bool { true }

    private func setactionList(leftAction: String?, rightAction: String) {
        leftBtn.removeFromSuperview()
        rightBtn.removeFromSuperview()

        addSubview(rightBtn)
        rightBtn.title = rightAction

        var leftView: NSView = self

        if let action = leftAction {
            leftView = betweenLineVI
            addSubview(leftBtn)
            leftBtn.title = action
            wisdom_addConstraint(with: leftBtn,
                                 topView: acrossLineVI, leftView: self, bottomView: self, rightView: betweenLineVI,
                                 edgeInset: NSEdgeInsets(top: 1, left: 5, bottom: 0, right: -5))
        }

        wisdom_addConstraint(with: rightBtn,
                             topView: acrossLineVI, leftView: leftView, bottomView: self, rightView: self,
                             edgeInset: NSEdgeInsets(top: -1, left: 5, bottom: 0, right: -5))
    }

    @objc private func clickLeftBtn(_ sender: NSButton) {
        if actionClosure(sender.title, .left) {
            if superview != nil {
                WisdomHUDMacCore.dismissAction()
            }
        }
    }

    @objc private func clickRightBtn(_ sender: NSButton) {
        if actionClosure(sender.title, .right) {
            if superview != nil {
                WisdomHUDMacCore.dismissAction()
            }
        }
    }
}


extension WisdomHUDMacActionView {

    func setLeftAction(textColor: NSColor?, textFont: NSFont?) -> Self {
        if let c = textColor { leftBtn.contentTintColor = c }
        if let f = textFont { leftBtn.font = f }
        return self
    }

    func setRightAction(textColor: NSColor?, textFont: NSFont?) -> Self {
        if let c = textColor { rightBtn.contentTintColor = c }
        if let f = textFont { rightBtn.font = f }
        return self
    }

    func setTextFont(font: NSFont) -> Self {
        textLabel.font = font
        return self
    }

    func setTextColor(color: NSColor) -> Self {
        textLabel.textColor = color
        return self
    }

    func setTextAlignment(alignment: NSTextAlignment) -> Self {
        textLabel.alignment = alignment
        return self
    }

    func setLabelFont(font: NSFont) -> Self {
        tailLabel.font = font
        return self
    }

    func setLabelColor(color: NSColor) -> Self {
        tailLabel.textColor = color
        return self
    }
}


class WisdomHUDMacActionThemeView: WisdomHUDMacActionView {

    override init(title: String, text: String, label: String?, leftAction: String?, rightAction: String,
                  actionClosure: @escaping (String, WisdomActionValueStyle) -> (Bool)) {
        super.init(title: title, text: text, label: label, leftAction: leftAction, rightAction: rightAction,
                   actionClosure: actionClosure)
        titleLabel.stringValue = title
        textLabel.stringValue = text
        tailLabel.stringValue = label ?? ""

        if titleLabel.stringValue.isEmpty {
            titleLabel.stringValue = " "
        }
        if text.isEmpty {
            titleTopConstraint?.constant = 2
        }
        if (label ?? "").isEmpty {
            hitView.isHidden = true
            hitBottomConstraint?.constant = -5
        }
        betweenLineVI.isHidden = (leftAction == nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    func setThemeStyle(themeStyle: WisdomColorThemeStyle) {
        let colors = WisdomColorThemeStyle.getMacColor(themeStyle: themeStyle)
        layer?.backgroundColor = colors.HUDColor.cgColor
        titleLabel.textColor = colors.TitleColor
        textLabel.textColor = colors.TextColor
        hitView.layer?.backgroundColor = colors.TailColor.withAlphaComponent(0.3).cgColor
        tailLabel.textColor = colors.TailColor
        leftBtn.contentTintColor = colors.TitleColor
        rightBtn.contentTintColor = colors.TitleColor
        titleLineVI.layer?.backgroundColor = colors.LineColor.cgColor
        acrossLineVI.layer?.backgroundColor = colors.LineColor.cgColor
        betweenLineVI.layer?.backgroundColor = colors.LineColor.cgColor

        layer?.cornerRadius = 6
        layer?.shadowOffset = .zero
        layer?.shadowOpacity = 0.3
        layer?.shadowRadius = 6
        layer?.shadowColor = colors.LayerColor.cgColor
    }
}

#endif
