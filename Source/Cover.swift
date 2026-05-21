//
//  Cover.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/10/20.
//
//  跨平台 HUD 遮罩 view:挂 SceneView 或 ActionView,链式 setter 转发到内部 view。
//  iOS/tvOS 基于 UIView,macOS 基于 NSView,通过 Able.swift 的 WisdomHUDView 桥接。
//

#if os(iOS) || os(tvOS) || os(macOS)

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
// macOS 端 SceneView/ActionThemeView 仍带 Mac 后缀,这里用 typealias 让 Cover 用统一名引用
typealias WisdomHUDSceneView       = WisdomHUDMacSceneView
typealias WisdomHUDActionThemeView = WisdomHUDMacActionThemeView
typealias WisdomHUDMacCoverView    = WisdomHUDCoverView
#endif


final class WisdomHUDCoverView: WisdomHUDView {

    private(set) var isSetting = false
    
    weak var sceneView: WisdomHUDSceneView?
    
    weak var actionView: WisdomHUDActionThemeView?
    
    #if os(macOS)
    // NSView.tag is get-only;macOS 用存储属性 override,提供 setWisdomTag(_:) 写入入口
    private var _wisdomTag: Int = 0
    override var tag: Int { _wisdomTag }
    func setWisdomTag(_ value: Int) { _wisdomTag = value }
    
    override var isFlipped: Bool { true }
    #endif

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        #if os(macOS)
        wantsLayer = true
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(Swift.type(of: self)) deinit")
    }
}

extension WisdomHUDCoverView: @MainActor WisdomHUDContextable {
    
    func setFocusing()->Self {
        isSetting = true
        
        if let cur_sceneView = sceneView {
            backgroundColor = UIColor.clear
            
            let coverConstraints = constraints.filter {
                $0.identifier == WisdomHUDCore.getWisdomHUD_Focusing()
            }
            let superConstraints = superview?.constraints.filter {
                $0.identifier == WisdomHUDCore.getWisdomHUD_Focusing()
            }
            removeConstraints(coverConstraints)
            superview?.removeConstraints(superConstraints ?? [])
            
            #if os(iOS) || os(tvOS)
            superview?.layoutIfNeeded()
            #elseif os(macOS)
            superview?.layoutSubtreeIfNeeded()
            #endif
            
            if cur_sceneView.placeStyle == .bottom {
                superview?.wisdom_addConstraint(toCenterX: self, toCenterY: nil)
                superview?.addConstraint(NSLayoutConstraint(item: self,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                          toItem: superview,
                                                       attribute: .bottom,
                                                      multiplier: 1.0,
                                                        constant: -(superview?.frame.height ?? 0)/10.5))
            }else {
                superview?.wisdom_addConstraint(toCenterX: self, toCenterY: self)
            }
            
            wisdom_addConstraint(with: cur_sceneView,
                                 topView: self,
                                 leftView: self,
                                 bottomView: self,
                                 rightView: self,
                                 edgeInset: WisdomHUDEdgeInsets.zero)
            
            if cur_sceneView.hudStyle != .text{
                cur_sceneView.set_imageContentSize()
            }
        }
        return self
    }
}

extension WisdomHUDCoverView: @MainActor WisdomHUDLoadingContextable {
    
    func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self {
        isSetting = true
        _=sceneView?.setTimeout(time: time, timeoutClosure: timeoutClosure)
        return self
    }
}

extension WisdomHUDCoverView: @MainActor WisdomHUDBaseContextable {
    
    func setTextFont(font: WisdomHUDFont)->Self {
        _=sceneView?.setTextFont(font: font)
        return self
    }
    
    func setTextColor(color: WisdomHUDColor)->Self {
        _=sceneView?.setTextColor(color: color)
        return self
    }
    
    func setUpdateText(text: String)->Self {
        _=sceneView?.setUpdateText(text: text)
        return self
    }
    
    func setAnimation(view: WisdomHUDView)->Self {
        isSetting = true
        _=sceneView?.setAnimation(view: view)
        return self
    }
}

extension WisdomHUDCoverView: @MainActor WisdomHUDProgreContextable {
    
    func setProgreColor(color: WisdomHUDColor)->Self {
        _=sceneView?.setProgreColor(color: color)
        return self
    }
    
    func setProgreValue(value: UInt)->Self {
        _=sceneView?.setProgreValue(value: value)
        return self
    }
    
    func setProgreTextColor(color: WisdomHUDColor)->Self {
        _=sceneView?.setProgreTextColor(color: color)
        return self
    }
    
    func setProgreShadowColor(color: WisdomHUDColor)->Self {
        _=sceneView?.setProgreShadowColor(color: color)
        return self
    }
}

extension WisdomHUDCoverView: @MainActor WisdomHUDActionContextable {
    
    func setLeftAction(textColor: WisdomHUDColor?, textFont: WisdomHUDFont?)->Self {
        _=actionView?.setLeftAction(textColor: textColor, textFont: textFont)
        return self
    }
    
    func setRightAction(textColor: WisdomHUDColor?, textFont: WisdomHUDFont?)->Self {
        _=actionView?.setRightAction(textColor: textColor, textFont: textFont)
        return self
    }
    
    func setTextAlignment(alignment: NSTextAlignment)->Self {
        _=actionView?.setTextAlignment(alignment: alignment)
        return self
    }
    
    func setActionTextFont(font: WisdomHUDFont)->Self {
        _=actionView?.setTextFont(font: font)
        return self
    }
    
    func setActionTextColor(color: WisdomHUDColor)->Self {
        _=actionView?.setTextColor(color: color)
        return self
    }
    
    func setLabelFont(font: WisdomHUDFont) -> Self {
        _=actionView?.setLabelFont(font: font)
        return self
    }
    
    func setLabelColor(color: WisdomHUDColor) -> Self {
        _=actionView?.setLabelColor(color: color)
        return self
    }
}

#endif // os(iOS) || os(tvOS) || os(macOS)
