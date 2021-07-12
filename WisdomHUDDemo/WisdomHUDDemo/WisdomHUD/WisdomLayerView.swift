//
//  WisdomLayerView.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

public class WisdomLayerView: UIView {
    
    fileprivate let HUD_CornerRadius: CGFloat = 10.0

    fileprivate let HUD_MIN_Width: CGFloat = 110

    fileprivate let HUD_MAX_Width: CGFloat = 200

    fileprivate let HUD_Text_Padding_LRT: CGFloat = 12.0

    fileprivate let HUD_Text_Padding_Middle: CGFloat = 5.0

    fileprivate let HUD_Text_Padding_Bottom: CGFloat = 10.0

    fileprivate let HUD_Text_Font: CGFloat = 13.0
    
    
    fileprivate var text: String?
    
    fileprivate var textColor: UIColor?
    
    fileprivate let type: WisdomHUDType!
    
    fileprivate let barStyle: WisdomCoverBarStyle!
    
    fileprivate let loadingStyle: WisdomLoadingStyle!

    fileprivate var delay: TimeInterval!
    
    
    fileprivate var imageView: UIImageView?
    
    fileprivate var loadImageView: UIImageView?
    
    fileprivate var activityView: UIActivityIndicatorView?
    
    fileprivate lazy var textLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: HUD_Text_Font)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    
    fileprivate var selfWidth: CGFloat = 85
    
    fileprivate var selfHeight: CGFloat = 85
    
    fileprivate var delayHander: ((TimeInterval, WisdomHUDType)->())?
    
    
    @objc public init(texts: String?,
                      textColor: UIColor?,
                      types: WisdomHUDType,
                      barStyle: WisdomCoverBarStyle,
                      loadingStyle: WisdomLoadingStyle=wisdomLoadingStyle,
                      delays: TimeInterval) {
        text = texts
        self.textColor = textColor
        type = types
        self.barStyle = barStyle
        self.loadingStyle = loadingStyle
        delay = delays
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.blue
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setbarUI()
        
        settextUI()
        
        addConstraint(width: selfWidth, height: selfHeight)
    }
    
    
    private func setbarUI() {
        
        func addImageView(image: UIImage) {
            imageView = UIImageView(image: image)
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView!)
            
            generalConstraint(at: imageView!)
        }
        
        switch barStyle {
        case .dark:
            backgroundColor = UIColor.black.withAlphaComponent(0.75)
            textLabel.textColor = textColor != nil ? textColor : UIColor.white
        //case .light:
        //    backgroundColor = UIColor.white.withAlphaComponent(0.75)
        //    textLabel.textColor = textColor != nil ? textColor : UIColor.black
        case .skyBlue:
            backgroundColor = UIColor(red: 18/255, green: 112/255, blue: 238/255, alpha: 0.8)
            textLabel.textColor = textColor != nil ? textColor : UIColor.white
        case .hide:
            backgroundColor = UIColor.clear
            textLabel.textColor = textColor != nil ? textColor : UIColor.white
        default: break
        }
        
        switch type {
        case .success:
            addImageView(image: WisdomHUDImage.imageOfSuccess)
        case .error:
            addImageView(image: WisdomHUDImage.imageOfError)
        case .warning:
            addImageView(image: WisdomHUDImage.imageOfWarning)
        case .loading:
            addActivityView()
        case .textCentre, .textRoot:
            break
        default:
            break
        }
        
        layer.cornerRadius = HUD_CornerRadius
    }
    
    
    private func settextUI() {
        
        if let info = text {
            var labelY: CGFloat = 0.0
            if type == .textCentre || type == .textRoot {
                labelY = HUD_Text_Padding_Bottom
            } else {
                labelY = HUD_Text_Padding_LRT + HUD_ImageWidth_Height + HUD_Text_Padding_Middle
            }
            
            textLabel.text = info
            
            textLabel.numberOfLines = 0
            
            addSubview(textLabel)
            
            addConstraint(to: textLabel, edageInset: UIEdgeInsets(top: labelY,
                                                                  left: HUD_Text_Padding_LRT,
                                                                  bottom: -HUD_Text_Padding_Bottom,
                                                                  right: -HUD_Text_Padding_LRT))
            
            textLabel.sizeToFit()
            
            let textSize: CGSize = size_maxWH(from: info)

            if textSize.width + HUD_Text_Padding_LRT*2 > HUD_MAX_Width {
                let infoSize: CGSize = size_maxHeight(from: info)
                
                selfWidth = HUD_MAX_Width
                selfHeight = labelY + infoSize.height + HUD_Text_Padding_Bottom + HUD_Text_Font/4.0
                
            }else if textSize.width + HUD_Text_Padding_LRT*2 < HUD_MIN_Width {
                selfWidth = HUD_MIN_Width
                selfHeight = labelY + textSize.height + HUD_Text_Padding_Bottom + HUD_Text_Font/4.0
            }else {
                selfWidth = textSize.width + HUD_Text_Padding_LRT*2 + HUD_Text_Font/1.5
                selfHeight = labelY + textSize.height + HUD_Text_Padding_Bottom + HUD_Text_Font/4.0
            }
        }
    }
    
    
    private func size_maxHeight(from text:String) -> CGSize {
        return text.textSizeWithFont(font: UIFont.systemFont(ofSize: HUD_Text_Font),
                                     constrainedToSize: CGSize(width:HUD_MAX_Width - HUD_Text_Padding_LRT*2,
                                                               height:CGFloat(MAXFLOAT)))
    }
    
    
    private func size_maxWH(from text:String) -> CGSize {
        return text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: HUD_Text_Font)])
    }

    
    private func addActivityView() {
        switch loadingStyle {
        case .system:
            activityView = UIActivityIndicatorView(style: .whiteLarge)
            activityView?.translatesAutoresizingMaskIntoConstraints = false
            activityView?.startAnimating()
            addSubview(activityView!)
            generalConstraint(at: activityView!)

        case .rotate:
            let loadRotateImag = bundleImage(name: "loadRotate")
            loadImageView = UIImageView(image: loadRotateImag)
            loadImageView?.translatesAutoresizingMaskIntoConstraints = false

            addRotationAnim(imageView: loadImageView!)
            addSubview(loadImageView!)
            loadGeneralConstraint(at: loadImageView!)
        case .rotateBlue:
            let loadRotateImag = bundleImage(name: "loadRotateBlue")
            loadImageView = UIImageView(image: loadRotateImag)
            loadImageView?.translatesAutoresizingMaskIntoConstraints = false

            addRotationAnim(imageView: loadImageView!)
            addSubview(loadImageView!)
            loadGeneralConstraint(at: loadImageView!)
            
            textLabel.textColor = textColor != nil ? textColor : UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
        default:
            break
        }
    }
    
    
    private func generalConstraint(at view: UIView) {

        view.addConstraint(width: HUD_ImageWidth_Height, height: HUD_ImageWidth_Height)

        if text != nil && text!.count > 0 {
            addConstraint(toCenterX: view, toCenterY: nil)
            
            addConstraint(with: view,
                          topView: self,
                          leftView: nil,
                          bottomView: nil,
                          rightView: nil,
                          edgeInset: UIEdgeInsets(top: HUD_Text_Padding_LRT, left: 0, bottom: 0, right: 0))
        }else {
            addConstraint(toCenterX: view, toCenterY: view)
        }
    }
    
    
    private func loadGeneralConstraint(at view: UIImageView) {

        view.addConstraint(width: HUD_ImageWidth_Height, height: HUD_ImageWidth_Height)

        if text != nil && text!.count > 0 {
            addConstraint(toCenterX: view, toCenterY: nil)

            let topConstraint = NSLayoutConstraint(item: view, attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute:.top,
                                                   multiplier: 1.0,
                                                   constant: HUD_Text_Padding_LRT)
            addConstraint(topConstraint)
        }else {
            addConstraint(toCenterX: view, toCenterY: view)
        }
    }
    
    
    /* bundle图片 */
    fileprivate func bundleImage(name: String)-> UIImage {
        let bundle = Bundle.init(path:Bundle.init(for: WisdomHUD.self).path(forResource: "WisdomHUD", ofType: "bundle")!)!
        let url = bundle.path(forResource: name, ofType: "png")!
        let image = UIImage(contentsOfFile: url)!
        return image
    }
    
    
    fileprivate func addRotationAnim(imageView: UIImageView) {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 1
        rotationAnim.isRemovedOnCompletion = false
        imageView.layer.add(rotationAnim, forKey: nil)
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("WisdomLayerView-释放")
    }
}


extension WisdomLayerView {
    
    /* 定义任务结束时间回调 */
    @objc public func setDelayHander(delayHander: @escaping (TimeInterval, WisdomHUDType)->() ){
        self.delayHander = delayHander
    }
    
    
    /* Success HUD */
    static func showSuccess(text: String?,
                            textColor: UIColor?,
                            delay: TimeInterval,
                            barStyle: WisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView(texts: text,
                                        textColor: textColor,
                                        types: .success,
                                        barStyle: barStyle,
                                        delays: delay)
        
        layerView.showWindow()
        
        layerView.keepTime()
        
        return layerView
    }
    
    
    /* Error HUD */
    static func showError(text: String?,
                          textColor: UIColor?,
                          delay: TimeInterval,
                          barStyle: WisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView(texts: text,
                                        textColor: textColor,
                                        types: .error,
                                        barStyle: barStyle,
                                        delays: delay)
        
        layerView.showWindow()
        
        layerView.keepTime()
        
        return layerView
    }
    
    
    /* Warning HUD */
    static func showWarning(text: String?,
                            textColor: UIColor?,
                            delay: TimeInterval,
                            barStyle: WisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView(texts: text,
                                        textColor: textColor,
                                        types: .warning,
                                        barStyle: barStyle,
                                        delays: delay)
        
        layerView.showWindow()
        
        layerView.keepTime()
        
        return layerView
    }
    
    
    /* Loading HUD */
    static func showLoading(text: String?,
                            textColor: UIColor?,
                            barStyle: WisdomCoverBarStyle,
                            loadingStyle: WisdomLoadingStyle) {
        let layerView = WisdomLayerView(texts: text,
                                        textColor: textColor,
                                        types: .loading,
                                        barStyle: barStyle,
                                        delays: wisdomDelayTimes)
        
        layerView.showWindow()
    }
    
    
    /* Text HUD */
    static func showText(text: String?,
                         textColor: UIColor?,
                         delay: TimeInterval,
                         barStyle: WisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView(texts: text,
                                        textColor: textColor,
                                        types: .textCentre,
                                        barStyle: barStyle,
                                        delays: delay)
        
        layerView.showWindow()
        
        layerView.keepTime()
        
        return layerView
    }
    
    
    /* Text Root HUD */
    static func showTextRoot(text: String?,
                             textColor: UIColor?,
                             delay: TimeInterval,
                             barStyle: WisdomCoverBarStyle)-> WisdomLayerView {
        let layerView = WisdomLayerView(texts: text,
                                        textColor: textColor,
                                        types: .textRoot,
                                        barStyle: barStyle,
                                        delays: delay)
        
        layerView.showWindow()
        
        layerView.keepTime()
        
        return layerView
    }

}


extension WisdomLayerView {
    
    /* 展示 */
    private func showWindow() {
        let window = UIApplication.shared.keyWindow
        let currentView = window?.viewWithTag(WisdomHUDWindowTag)
        let offsetY = window!.bounds.size.height/10.0
        
        if let hudCoverVI = currentView as? WisdomLayerCoverView {
            for view in hudCoverVI.subviews {
                view.removeFromSuperview()
            }
            
            hudCoverVI.addSubview(self)
            
            if type == WisdomHUDType.textRoot {
                hudCoverVI.addConstraint(toCenterX: self, toCenterY: nil)
                
                hudCoverVI.addConstraint(NSLayoutConstraint(item: self,
                                                            attribute: .bottom,
                                                            relatedBy: .equal,
                                                            toItem: hudCoverVI,
                                                            attribute: .bottom,
                                                            multiplier: 1,
                                                            constant: -offsetY))
            }else {
                hudCoverVI.addConstraint(toCenterX: self, toCenterY: self)
            }
        }else {
            let coverVI = WisdomLayerCoverView()
            
            coverVI.translatesAutoresizingMaskIntoConstraints = false
            
            coverVI.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            coverVI.tag = WisdomHUDWindowTag
           
            window?.addSubview(coverVI)
            
            window!.addConstraint(with: coverVI,
                              topView: window!,
                             leftView: window!,
                           bottomView: window!,
                            rightView: window!,
                            edgeInset: UIEdgeInsets.zero)
            
            coverVI.addSubview(self)
            
            if type == WisdomHUDType.textRoot {
                coverVI.addConstraint(toCenterX: self, toCenterY: nil)
                
                coverVI.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: coverVI,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: -offsetY))
            }else {
                coverVI.addConstraint(toCenterX: self, toCenterY: self)
            }
        }
    }
    
    
    /* 计时移除 */
    private func keepTime() {
        func setAlpha() {
            self.alpha = 0
            self.superview?.alpha = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            
            UIView.animate(withDuration: 0.5, animations: {
                setAlpha()
            }) { _ in
                self.delayHander?(self.delay, self.type)
                WisdomHUD.dismiss()
            }
        })
    }
}


public class WisdomLayerCoverView: UIView {
    
    
}
