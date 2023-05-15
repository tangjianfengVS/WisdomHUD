//
//  Scene.swift
//  WisdomHUD
//
//  Created by 汤建锋 on 2022/9/30.
//

import UIKit


struct WisdomHUDContent {
    
    private(set) var bar_Size = CGSize(width: 97, height: 94)
    
    private(set) var icon_Size: CGFloat = 29
    
    let text_Font: CGFloat = 13.2
    
    let top_icon_space: CGFloat = 20
    
    let top_text_space: CGFloat = 11
    
    let lr_text_space: CGFloat = 12
    
    let bottom_text_space: CGFloat = 13
    
    
    fileprivate func getContentHeight()->CGFloat{
        return top_icon_space + icon_Size + top_text_space + bottom_text_space
    }
    
    fileprivate mutating func updateIcon_Size(icon_Size: CGFloat, needUpdateBar: Bool?=false){
        self.icon_Size = icon_Size
        if needUpdateBar==true {
            self.bar_Size = CGSize(width: 97+(97-icon_Size)/3.5, height: 94)
        }
    }
}


final class WisdomHUDSceneView: UIView {

    private(set) var content = WisdomHUDContent()
    
    let hudStyle: WisdomHUDStyle
    
    private var barStyle: WisdomSceneBarStyle
    
    private var loadingStyle: WisdomLoadingStyle?
    
    private var progreStyle: WisdomProgreStyle?
    
    private(set) var placeStyle: WisdomTextPlaceStyle?
    
    private var delayClosure: ((TimeInterval)->())?
    
    private var shadowColor: UIColor = .black
    
    private lazy var imageView: WisdomHUDImageView = {
        let vi = WisdomHUDImageView(frame: .zero)
        addSubview(vi)
        return vi
    }()
    
    private lazy var textLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.white
        $0.numberOfLines = WisdomHUDCore.WisdomTextMaxLineStyle.rawValue
        $0.textAlignment = .center
        var maxWidth = (UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width)*0.65
        if maxWidth > 420 {
            maxWidth = 420
        }
        $0.preferredMaxLayoutWidth = maxWidth
        
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
    
    init(hudStyle: WisdomHUDStyle, barStyle: WisdomSceneBarStyle, placeStyle: WisdomTextPlaceStyle?) {
        self.hudStyle = hudStyle
        self.barStyle = barStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setStyleContent(barStyle: barStyle, placeStyle: placeStyle)
        
        addConstraint(widthConstraint)
        addConstraint(heightConstraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImage_TextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        self.delayClosure = delayClosure
        
        wisdom_addConstraint(toCenterX: imageView, toCenterY: nil)
        
        imageView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)
        
        addConstraint(NSLayoutConstraint(item: imageView,
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
                                         toItem: imageView,
                                         attribute:.bottom,
                                         multiplier: 1.0,
                                         constant: content.top_text_space))
        
        set_imageContentSize()
        
        set_shadowColor(cornerRadius: 10)
    
        startDelays(delays: delays)
    }
    
    private func set_TextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        self.delayClosure = delayClosure
    
        // textLabel layout
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: content.text_Font)
        
        wisdom_addConstraint(toCenterX: textLabel, toCenterY: textLabel)
        
        set_textContentSize()
        
        set_shadowColor(cornerRadius: 6)
    
        startDelays(delays: delays)
    }
    
    func set_imageContentSize() {
        textLabel.sizeToFit()
        layoutIfNeeded()
        
        if textLabel.bounds.width + content.lr_text_space*2 >= content.bar_Size.width {
            widthConstraint.constant = textLabel.bounds.width + content.lr_text_space*2
        }
        
        if content.getContentHeight() + textLabel.bounds.height >= content.bar_Size.height{
            heightConstraint.constant = content.getContentHeight() + textLabel.bounds.height
        }
    }
    
    private func set_textContentSize() {
        widthConstraint.constant = 85
        heightConstraint.constant = 43
        
        textLabel.sizeToFit()
        layoutIfNeeded()
        
        if textLabel.bounds.width+15*2 >= widthConstraint.constant {
            widthConstraint.constant = textLabel.bounds.width+15*2
        }
        
        if textLabel.bounds.height+10*2 >= heightConstraint.constant {
            heightConstraint.constant = textLabel.bounds.height+10*2
        }
    }
    
    private func set_shadowColor(cornerRadius: CGFloat) {
        layoutIfNeeded()
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        layer.cornerRadius = cornerRadius
        let path = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: cornerRadius/2, height: cornerRadius/2))
        layer.shadowPath = path.cgPath
    }
    
    deinit {
        print("\(self.classForCoder) deinit")
    }
}

extension WisdomHUDSceneView: WisdomHUDContentable {
    
    func setLoadingContent(text: String, loadingStyle: WisdomLoadingStyle, timeout: (TimeInterval, (TimeInterval)->())?) {
        self.loadingStyle = loadingStyle
        
        if loadingStyle == .chaseBall {
            content.updateIcon_Size(icon_Size: content.icon_Size+2.5)
        }
        
        imageView.setLoadingImage(size: content.icon_Size, loadingStyle: loadingStyle, barStyle: barStyle)
        
        imageView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)
        
        if text.isEmpty {
            wisdom_addConstraint(toCenterX: imageView, toCenterY: imageView)
        }else {
            // iconView layout
            wisdom_addConstraint(toCenterX: imageView, toCenterY: nil)
            
            addConstraint(NSLayoutConstraint(item: imageView,
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
                                             toItem: imageView,
                                             attribute:.bottom,
                                             multiplier: 1.0,
                                             constant: content.top_text_space))
            
            set_imageContentSize()
        }
        
        set_shadowColor(cornerRadius: 10)
        
        if let timeoutInfo = timeout {
            _=setTimeout(time: timeoutInfo.0, timeoutClosure: timeoutInfo.1)
        }
    }
    
    func setProgressContent(text: String, progreStyle: WisdomProgreStyle, timeout: (TimeInterval, (TimeInterval)->())?){
        self.progreStyle = progreStyle
        
        content.updateIcon_Size(icon_Size: content.icon_Size*1.7, needUpdateBar: !text.isEmpty)
        
        widthConstraint.constant = content.bar_Size.width
        
        heightConstraint.constant = content.bar_Size.height
        
        imageView.setProgressImage(size: content.icon_Size, progreStyle: progreStyle, barStyle: barStyle)
        
        imageView.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)
        
        if text.isEmpty {
            wisdom_addConstraint(toCenterX: imageView, toCenterY: imageView)
        }else {
            // iconView layout
            wisdom_addConstraint(toCenterX: imageView, toCenterY: nil)
            
            addConstraint(NSLayoutConstraint(item: imageView,
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
                                             toItem: imageView,
                                             attribute:.bottom,
                                             multiplier: 1.0,
                                             constant: content.top_text_space))
            
            set_imageContentSize()
        }
        
        set_shadowColor(cornerRadius: 10)
        
        if let timeoutInfo = timeout {
            _=setTimeout(time: timeoutInfo.0, timeoutClosure: timeoutInfo.1)
        }
    }
    
    func setSuccessContent(text: String, animat: Bool, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
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
    
    func setTextContent(text: String, delays: TimeInterval, delayClosure: ((TimeInterval)->())?) {
        set_TextContent(text: text, delays: delays, delayClosure: delayClosure)
    }
    
    func setStyleContent(barStyle: WisdomSceneBarStyle, placeStyle: WisdomTextPlaceStyle?) {
        self.barStyle = barStyle
        self.placeStyle = placeStyle
        
        switch barStyle {
        case .dark:
            backgroundColor = UIColor.black.withAlphaComponent(0.90)
            textLabel.textColor = UIColor.white
            shadowColor = UIColor.white.withAlphaComponent(0.12)
        case .light:
            backgroundColor = UIColor.white.withAlphaComponent(0.95)
            textLabel.textColor = UIColor.black
            shadowColor = UIColor.black.withAlphaComponent(0.1)
        case .hide:
            backgroundColor = UIColor.clear
            textLabel.textColor = UIColor.white
            shadowColor = UIColor.clear
        default:
            backgroundColor = UIColor.black.withAlphaComponent(0.90)
            textLabel.textColor = UIColor.white
            shadowColor = UIColor.white.withAlphaComponent(0.12)
        }
    }
    
    func setDismissImage() {
        if loadingStyle != nil || progreStyle != nil {
            imageView.setDismissImage()
        }
    }
}

extension WisdomHUDSceneView: WisdomHUDLoadingContextable {
    
    func setTimeout(time: TimeInterval, timeoutClosure: @escaping ((TimeInterval)->()))->Self {
        self.delayClosure = timeoutClosure
        startDelays(delays: time)
        return self
    }
    
    func setTextFont(font: UIFont)->Self {
        if textLabel.text?.count ?? 0 > 0 {
            textLabel.font = font
            
            if hudStyle == .text {
                set_textContentSize()
            }else {
                set_imageContentSize()
            }
        }
        return self
    }
    
    func setTextColor(color: UIColor)->Self {
        if textLabel.text?.count ?? 0 > 0 {
            textLabel.textColor = color
        }
        return self
    }
    
    func setUpdateText(text: String)->Self {
        textLabel.text = text
        if hudStyle == .text {
            set_textContentSize()
        }else {
            set_imageContentSize()
        }
        return self
    }
    
    func setAnimation(view: UIView)->Self {
        if hudStyle == .text {
            return self
        }
        imageView.removeFromSuperview()
        imageView.isHidden=true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.wisdom_addConstraint(width: content.icon_Size, height: content.icon_Size)

        if (textLabel.text ?? "").isEmpty {
            wisdom_addConstraint(toCenterX: view, toCenterY: view)
        }else {
            // iconView layout
            wisdom_addConstraint(toCenterX: view, toCenterY: nil)

            addConstraint(NSLayoutConstraint(item: view,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .top,
                                             multiplier: 1.0,
                                             constant: content.top_icon_space))
            
            addConstraint(NSLayoutConstraint(item: textLabel,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: view,
                                             attribute:.bottom,
                                             multiplier: 1.0,
                                             constant: content.top_text_space))
            set_imageContentSize()
        }
        return self
    }
}

extension WisdomHUDSceneView: WisdomHUDProgreContextable {
    
    func setProgreColor(color: UIColor)->Self {
        if progreStyle != nil {
            imageView.setProgreColor(color: color)
        }
        return self
    }
    
    func setProgreValue(value: UInt)->Self {
        if progreStyle != nil {
            imageView.setProgreValue(value: value)
        }
        return self
    }
    
    func setProgreTextColor(color: UIColor)->Self {
        if progreStyle != nil {
            imageView.setProgreTextColor(color: color)
        }
        return self
    }

    func setProgreShadowColor(color: UIColor)->Self {
        if progreStyle != nil {
            imageView.setProgreShadowColor(color: color)
        }
        return self
    }
}

extension WisdomHUDSceneView: WisdomHUDDelaysable {
    
    func startDelays(delays: TimeInterval) {
        func setAlpha() {
            superview?.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delays, execute: {
            UIView.animate(withDuration: 0.30, animations: {
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { [weak self] in
            if let _ = self?.superview{
                WisdomHUDCore.dismiss()
            }
        })
    }
    
    func executeDelayClosure(){
        if let closure = delayClosure {
            closure(-1)
        }
        delayClosure = nil
        
        setDismissImage()
    }
}
