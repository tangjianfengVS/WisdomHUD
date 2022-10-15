//
//  WisdomHUDSceneView.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/9/30.
//

import UIKit


struct WisdomHUDContent {
    
    let bar_Size = CGSize(width: 97, height: 92)
    
    let text_Font: CGFloat = 13.2
    
    private(set) var icon_Size: CGFloat = 29
    
    let top_icon_space: CGFloat = 20
    
    let top_text_space: CGFloat = 10
    
    let lr_text_space: CGFloat = 12
    
    let bottom_text_space: CGFloat = 12
    
    
    func getContentHeight()->CGFloat{
        return top_icon_space + icon_Size + top_text_space + bottom_text_space
    }
    
    mutating func updateIcon_Size(icon_Size: CGFloat){
        self.icon_Size = icon_Size
    }
}


final class WisdomHUDSceneView: UIView {

    private(set) var content = WisdomHUDContent()
    
    let hudStyle: WisdomHUDStyle
    
    let barStyle: WisdomSceneBarStyle
    
    private var delayClosure: ((TimeInterval)->())?
    
    private lazy var iconView: WisdomHUDIconView = {
        let vi = WisdomHUDIconView(frame: .zero)
        addSubview(vi)
        return vi
    }()
    
    private lazy var textLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.white
        $0.numberOfLines = 2
        $0.textAlignment = .center
        let maxWidth = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        $0.preferredMaxLayoutWidth = maxWidth/1.7
        
        addSubview($0)
        return $0
    }(UILabel())
    
    private lazy var widthConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self,
                             attribute: .width,
                             relatedBy: .equal,
                                toItem: nil,
                             attribute: .width,
                                  multiplier: 1.0,
                              constant: content.bar_Size.width)
    }()
    
    private lazy var heightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self,
                             attribute: .height,
                             relatedBy: .equal,
                                toItem: nil,
                             attribute: .height,
                            multiplier: 1.0,
                              constant: content.bar_Size.height)
    }()
    
    private lazy var layerMask: Bool = {
        layoutIfNeeded()
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        let radiusLayer = CAShapeLayer()
        radiusLayer.frame = bounds
        radiusLayer.path = bezierPath.cgPath
        layer.mask = radiusLayer
        return true
    }()
    
    init(hudStyle: WisdomHUDStyle, barStyle: WisdomSceneBarStyle) {
        self.hudStyle = hudStyle
        self.barStyle = barStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        switch barStyle {
        case .dark:
            backgroundColor = UIColor.black.withAlphaComponent(0.80)
            textLabel.textColor = UIColor.white
        case .light:
            backgroundColor = UIColor(white: 1, alpha: 0.9)
            textLabel.textColor = UIColor.black
        //case .skyBlue:
        //    backgroundColor = UIColor(red: 18/255, green: 112/255, blue: 238/255, alpha: 0.8)
        //    textLabel.textColor = textColor != nil ? textColor : UIColor.white
        case .hide:
            backgroundColor = UIColor.clear
            textLabel.textColor = UIColor.white
        default:
            backgroundColor = UIColor.black.withAlphaComponent(0.80)
            textLabel.textColor = UIColor.white
        }
        addConstraint(widthConstraint)
        addConstraint(heightConstraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImage_TextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        self.delayClosure = delayClosure
        
        wisdom_addConstraint(toCenterX: iconView, toCenterY: nil)
        
        iconView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)
        
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: content.top_icon_space))
            
        // textLabel layout
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: content.text_Font)
        
        wisdom_addConstraint(toCenterX: textLabel, toCenterY: nil)
        
        addConstraint(NSLayoutConstraint(item: textLabel,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute:.bottom,
                                         multiplier: 1.0,
                                         constant: content.top_text_space))
        
        update_contentSize()
    
        startDelays(delays: delays)
        
        _=layerMask
    }
    
    private func setTextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        self.delayClosure = delayClosure
    
        // textLabel layout
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: content.text_Font)
        
        wisdom_addConstraint(toCenterX: textLabel, toCenterY: textLabel)
        
        widthConstraint.constant = 85
        heightConstraint.constant = 43
        
        textLabel.layoutIfNeeded()
        
        if textLabel.bounds.width+15*2 >= widthConstraint.constant {
            widthConstraint.constant = textLabel.bounds.width+15*2
        }
        
        if textLabel.bounds.height+10*2 >= heightConstraint.constant {
            heightConstraint.constant = textLabel.bounds.height+10*2
        }
    
        startDelays(delays: delays)
        
        layoutIfNeeded()
        let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 6, height: 6))
        let radiusLayer = CAShapeLayer()
        radiusLayer.frame = bounds
        radiusLayer.path = bezierPath.cgPath
        layer.mask = radiusLayer
    }
    
    private func update_contentSize() {
        textLabel.layoutIfNeeded()
        
        if textLabel.bounds.width + content.lr_text_space*2 >= content.bar_Size.width {
            widthConstraint.constant = textLabel.bounds.width + content.lr_text_space*2
        }
        
        if content.getContentHeight() + textLabel.bounds.height >= content.bar_Size.height{
            heightConstraint.constant = content.getContentHeight() + textLabel.bounds.height
        }
    }
}

extension WisdomHUDSceneView: WisdomHUDContentable {
    
    func setLoadingContent(text: String, loadingStyle: WisdomLoadingStyle) {
        if loadingStyle == .chaseBall {
            content.updateIcon_Size(icon_Size: content.icon_Size+4)
        }
        
        iconView.setLoadingIcon(size: content.icon_Size, loadingStyle: loadingStyle, barStyle: barStyle)
        
        iconView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)
        
        if text.isEmpty {
            wisdom_addConstraint(toCenterX: iconView, toCenterY: iconView)
        }else {
            // iconView layout
            wisdom_addConstraint(toCenterX: iconView, toCenterY: nil)
            
            addConstraint(NSLayoutConstraint(item: iconView,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .top,
                                             multiplier: 1.0,
                                             constant: content.top_icon_space))
            
            // textLabel layout
            textLabel.text = text
            textLabel.font = UIFont.systemFont(ofSize: content.text_Font)
            
            wisdom_addConstraint(toCenterX: textLabel, toCenterY: nil)
            
            addConstraint(NSLayoutConstraint(item: textLabel,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: iconView,
                                             attribute:.bottom,
                                             multiplier: 1.0,
                                             constant: content.top_text_space))
            
            update_contentSize()
        }
        _=layerMask
    }
    
    func setSuccessContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?){
        iconView.setSuccessIcon(size: content.icon_Size, barStyle: barStyle, animat: animat)
        
        setImage_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    func setErrorContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?){
        iconView.setErrorIcon(size: content.icon_Size, barStyle: barStyle, animat: animat)
        
        setImage_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    func setWarningContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval) -> ())?){
        iconView.setWarningIcon(size: content.icon_Size, barStyle: barStyle, animat: animat)
        
        setImage_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    func showTextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?){
        setTextContent(text: text, delays: delays, delayClosure: delayClosure)
    }
}

extension WisdomHUDSceneView: WisdomHUDDelaysable {
    
    func startDelays(delays: TimeInterval) {
        func setAlpha() {
            superview?.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delays, execute: {
            UIView.animate(withDuration: 0.25, animations: {
                setAlpha()
            }) { [weak self] _ in
                self?.endAnimate(delays: delays)
            }
        })
    }
    
    func endAnimate(delays: TimeInterval) {
        if let closure = delayClosure {
            closure(delays)
        }
        delayClosure = nil
        WisdomHUDOperate.dismiss()
    }
    
    func executeDelayClosure(){
        if let closure = delayClosure {
            closure(-1)
        }
        delayClosure = nil
    }
}
