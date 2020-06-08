//
//  WisdomLayerView.swift
//  WisdomScanKitDemo
//
//  Created by jianfeng on 2018/12/4.
//  Copyright © 2018年 All over the sky star. All rights reserved.
//

import UIKit

public class WisdomLayerView: UIView {

    fileprivate var delay: TimeInterval = HUD_DelayTime
    
    fileprivate var imageView: UIImageView?
    
    fileprivate var loadImageView: UIImageView?
    
    fileprivate var activityView: UIActivityIndicatorView?
    
    let type: WisdomHUDType!
    
    fileprivate var text: String?
    
    fileprivate var selfWidth: CGFloat = 90
    
    fileprivate var selfHeight: CGFloat = 90
    
    fileprivate var delayHander: ((TimeInterval, WisdomHUDType)->())?
    
    /** enable ：是否允许用户交互，默认允许 */
    @objc public init(texts: String?,
                      types: WisdomHUDType,
                      delays: TimeInterval,
                      enable: Bool = true,
                      offset: CGPoint = CGPoint(x: 0, y: -50)) {
        
        delay = delays
        text = texts
        type = types
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: selfWidth, height: selfHeight)))
        setupUI(enable: enable)
        addLabel()
        addHUDToKeyWindow(offset:offset)
    }
    
    
    private func setupUI(enable: Bool) {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = HUD_CornerRadius
        // setting width
        if text != nil && text!.count > 0 {
            let textSize: CGSize = size_maxWH(from: text!)
            
            if textSize.width + HUD_Text_Padding_LR*2 > HUD_MAX_Width {
                selfWidth = HUD_MAX_Width
            } else if textSize.width + HUD_Text_Padding_LR*2 < HUD_MIN_Width{
                selfWidth = HUD_MIN_Width
            }else{
                selfWidth = textSize.width + HUD_Text_Padding_LR*2
            }
        }
        
        guard let type = type else {
            return
        }
        
        switch type {
        case .success:
            addImageView(image: WisdomHUDImage.imageOfSuccess)
        case .error:
            addImageView(image: WisdomHUDImage.imageOfError)
        case .info:
            addImageView(image: WisdomHUDImage.imageOfInfo)
        case .loading:
            addActivityView()
        case .text:
            break
        }
        
        if !enable {
            UIApplication.shared.keyWindow!.addSubview(screenView)
        }
        
        let coverBarStyle = WisdomHUD.shared.coverBarStyle
        switch coverBarStyle {
        case .dark:
            backgroundColor = UIColor.black.withAlphaComponent(0.8)
            textLabel.textColor = UIColor.white
        case .light:
            backgroundColor = UIColor.white.withAlphaComponent(0.8)
            textLabel.textColor = UIColor.black
        case .skyBlue:
            backgroundColor = UIColor(red: 18/255, green: 112/255, blue: 238/255, alpha: 0.8)
            textLabel.textColor = UIColor.white
        }
    }
    
    
    private func addHUDToKeyWindow(offset:CGPoint) {
        guard self.superview == nil else { return }
        UIApplication.shared.keyWindow!.addSubview(self)
        self.alpha = 0
        
        addConstraint(width: selfWidth, height: selfHeight)
        UIApplication.shared.keyWindow!.addConstraint(toCenterX: self, constantx: offset.x, toCenterY: self, constanty: offset.y)
    }
    
    
    private func addLabel() {
        var labelY: CGFloat = 0.0
        if type == .text {
            labelY = HUD_Text_Padding_TB
        } else {
            labelY = HUD_Text_Padding_TB + HUD_ImageWidth_Height + HUD_Text_Padding_LR
        }
        
        if let text = text {
            textLabel.text = text
            addSubview(textLabel)
            textLabel.layoutIfNeeded()
            addConstraint(to: textLabel, edageInset: UIEdgeInsets(top: labelY,
                                                                  left: HUD_Text_Padding_LR,
                                                                  bottom: -HUD_Text_Padding_TB,
                                                                  right: -HUD_Text_Padding_LR))
            let textSize: CGSize = size_maxHeight(from: text)
            selfHeight = labelY + textSize.height + HUD_Text_Padding_TB
            selfWidth = selfWidth + 2
        }
    }
    
    
    private func size_maxHeight(from text:String) -> CGSize {
        return text.textSizeWithFont(font: HUD_Text_Font, constrainedToSize: CGSize(width:selfWidth - HUD_Text_Padding_LR*2, height:CGFloat(MAXFLOAT)))
    }
    
    
    private func size_maxWH(from text:String) -> CGSize {
        return text.size(withAttributes: [NSAttributedString.Key.font: HUD_Text_Font])
    }
    
    
    private func addImageView(image:UIImage) {
        imageView = UIImageView(image: image)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView!)
        
        generalConstraint(at: imageView!)
    }
    
    
    private func addActivityView() {
        let loadingStyle = WisdomHUD.shared.loadingStyle
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
        default:
            break
        }
    }
    
    
    private func generalConstraint(at view:UIView) {
        
        view.addConstraint(width: HUD_ImageWidth_Height, height: HUD_ImageWidth_Height)
        
        if text != nil && text!.count > 0 {
            addConstraint(toCenterX: view, toCenterY: nil)
            addConstraint(with: view,
                          topView: self,
                          leftView: nil,
                          bottomView: nil,
                          rightView: nil,
                          edgeInset: UIEdgeInsets(top: HUD_Text_Padding_TB, left: 0, bottom: 0, right: 0))
        } else {
            addConstraint(toCenterX: view, toCenterY: view)
        }
    }
    
    private func loadGeneralConstraint(at view: UIImageView) {
        
        view.addConstraint(width: HUD_ImageWidth_Height, height: HUD_ImageWidth_Height)
        
        if text != nil && text!.count > 0 {
            addConstraint(toCenterX: view, toCenterY: nil)
            
            let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute:.top, multiplier: 1.0, constant: HUD_Text_Padding_TB)
            addConstraint(topConstraint)
        } else {
            addConstraint(toCenterX: view, toCenterY: view)
        }
    }
    
    /** bundle图片 */
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
    
    private(set) lazy var screenView: UIView = {
        $0.frame = UIScreen.main.bounds
        $0.restorationIdentifier = WisdomHUDIdentifier
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return $0
    }(UIView())
    
    private lazy var textLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.white
        $0.font = HUD_Text_Font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    deinit {
        print("WisdomLayerView------释放: " + String(self.type.rawValue))
    }
}


extension WisdomLayerView {
    
    /** 1.定义任务结束时间回调 */
    @objc public func delayHanders(delayHanders: @escaping (TimeInterval, WisdomHUDType)->() ){
        delayHander = delayHanders
    }
    
    
    /**  2.成功提示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    static func showSuccess(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        var successStr = text
        if text == nil || text?.count == 0 {
            successStr = "Success"
        }
        return WisdomLayerView(texts: successStr, types: .success, delays: delay,enable: enable).show()
    }
    
    
    /**  3.失败提示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    static func showError(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        var errorStr = text
        if text == nil || text?.count == 0 {
            errorStr = "Error"
        }
        return WisdomLayerView(texts: errorStr, types: .error, delays: delay,enable:enable).show()
    }
    
    
    /**  4.警告信息提示展示
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    static func showInfo(text: String?, delay: TimeInterval, enable: Bool = true)-> WisdomLayerView {
        var infoStr = text
        if text == nil || text?.count == 0 {
            infoStr = "Info"
        }
        return WisdomLayerView(texts: infoStr, types: .info, delays: delay,enable:enable).show()
    }
    
    
    /**  5.耗时加载
     *   text:   Loading文字
     *   enable: 是否全屏遮罩
     */
    static func showLoading(text: String?, enable: Bool = false)-> WisdomLayerView {
        return WisdomLayerView(texts: text,types:.loading, delays: 0,enable:enable).show()
    }
    
    
    /**  6.无图片信息提示展示，纯文字
     *   text:   文字
     *   delay:  持续时间
     *   enable: 是否全屏遮罩
     */
    static func showText(text: String?, delay: TimeInterval, enable: Bool = false)-> WisdomLayerView {
        var textStr = text
        if text == nil || text?.count == 0 {
            textStr = "Text"
        }
        return WisdomLayerView(texts: textStr,types:.text,delays: delay,enable:enable).show()
    }
    
    /** 7.自定义展示 */
    @discardableResult
    public func show() -> WisdomLayerView {
        
        animate(hide: false) {
            if self.delay > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                    self.hide()
                })
            }
        }
        return self
    }
    
    /** 8.Hide func 移除屏幕展示 */
    @objc public func hide() {
        
        animate(hide: true, completion: {
            self.delayHander?(self.delay, self.type)
            self.removeFromSuperview()
            self.screenView.removeFromSuperview()
        })
    }
    
    /** 9.Hide func 延迟移除屏幕展示 */
    @objc public func hide(delay: TimeInterval = HUD_DelayTime) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.hide()
        })
    }
}
