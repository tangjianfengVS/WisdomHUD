//
//  WisdomHUDLogView.swift
//  WisdomHUDDemo
//
//  Created by 汤建锋 on 2022/12/17.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit

private var logView: WisdomHUDLogView?

class WisdomHUDLogView: UIView {
    
    static var isOpen = false
    
    let maxWidth: CGFloat = 414.0
    let maxHeight: CGFloat = 896.0-20.0

    let scrollView = UIScrollView()
    
    let textLabel = UILabel()
    
    //let backBtn = RCNavBackBtn()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(textLabel)

        wisdom_addConstraint(with: scrollView,
                             topView: self,
                             leftView: self,
                             bottomView: self,
                             rightView: self,
                             edgeInset: .zero)

        wisdom_addConstraint(with: textLabel,
                             topView: scrollView,
                             leftView: self,
                             bottomView: nil,
                             rightView: self,
                             edgeInset: UIEdgeInsets(top: 10, left: 8, bottom: 0, right: -8))
////        addSubview(backBtn)
//
////        backBtn.snp.makeConstraints { make in
////            make.top.equalTo(self).offset(5)
////            make.right.equalTo(self).offset(-5)
////            make.width.height.equalTo(32)
////        }
////        backBtn.backgroundColor = UIColor(white: 0, alpha: 0.4)
//        //backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
//
        textLabel.text = "[Initialization complete]"
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 13.5)
        textLabel.textAlignment = .left

        textLabel.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: bounds.size.width, height: textLabel.frame.maxY+10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String, textColor: UIColor){
        textLabel.text = (textLabel.text ?? "")+"\n"+text
        
        var attributedText = textLabel.attributedText
//        if attributedText == nil {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 3
            attributedText = NSAttributedString(string: textLabel.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: style])
//        }
//        var mutable = NSMutableAttributedString()
//        if let attri = textLabel.attributedText {//textLabel.text ?? ""
//            mutable = NSMutableAttributedString(attributedString: attri)
//        }
//
//        let strAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
//                       NSAttributedString.Key.foregroundColor: textColor]
//
//        mutable.addAttributes(strAttr, range: NSRangeFromString(text))
        
        textLabel.attributedText = attributedText
        
        textLabel.layoutIfNeeded()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: bounds.size.width, height: textLabel.frame.maxY+10)
    }
    
    @objc private func clickBackBtn(){
        UIView.animate(withDuration: 0.30) {[weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
            logView = nil
        }
    }
}

extension WisdomHUDLogView {
    
    class func setLog(isOpen: Bool) {
        WisdomHUDLogView.isOpen = isOpen
    }
    
    static func setPrint(text: String, textColor: UIColor) {
        if WisdomHUDLogView.isOpen {
            if Thread.isMainThread {
                setLog()
            }else {
                DispatchQueue.main.async { setLog() }
            }
            func setLog(){
    #if DEBUG
                if let cur_logView = logView, cur_logView.superview==nil {
                    logView = nil
                }
                if logView == nil, let screen = WisdomHUD.getScreenWindow() {
                    let vi = WisdomHUDLogView()
                    vi.backgroundColor = UIColor(white: 0, alpha: 0.4)
                    screen.addSubview(vi)
                    
                    let width: CGFloat = UIScreen.main.bounds.width > vi.maxWidth ? vi.maxWidth : UIScreen.main.bounds.width
                    screen.addConstraint(NSLayoutConstraint(item: vi,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1.0,
                                                            constant: width))
                    screen.addConstraint(NSLayoutConstraint(item: vi,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: screen,
                                                            attribute: .top,
                                                            multiplier: 1.0,
                                                            constant: 20))
                    screen.addConstraint(NSLayoutConstraint(item: vi,
                                                            attribute: .left,
                                                            relatedBy: .equal,
                                                            toItem: screen,
                                                            attribute: .left,
                                                            multiplier: 1.0,
                                                            constant: 0))
                    let height: CGFloat = UIScreen.main.bounds.height*0.5 > vi.maxHeight ? vi.maxHeight : UIScreen.main.bounds.height*0.5
                    screen.addConstraint(NSLayoutConstraint(item: vi,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1.0,
                                                            constant: height))
                    logView = vi
                }
    #endif
                if logView == nil {
                    print(text)
                }else {
                    logView?.setText(text: text, textColor: textColor)
                }
            }
        }
    }
}
