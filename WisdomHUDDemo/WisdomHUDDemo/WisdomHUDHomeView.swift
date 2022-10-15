//
//  WisdomHUDHomeView.swift
//  WisdomHUDDemo
//
//  Created by jianfeng tang on 2022/10/15.
//  Copyright © 2022 All over the sky star. All rights reserved.
//

import UIKit


// 进入下级图标
class CustomNextCell: UITableViewCell {
    
    private var loadingStyle: WisdomLoadingStyle?
    
    private var textPlaceStyle: WisdomTextPlaceStyle?
    
    let nextView = CustomNextView(frame: .zero)
    
    private var leftView: UIView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(nextView)
        
        nextView.snp.makeConstraints { make in
            make.bottom.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-1)
            make.left.equalTo(contentView).offset(0)
            make.right.equalTo(contentView).offset(-0)
        }
        
        nextView.layer.masksToBounds = true
        nextView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    //static var info: [String:Bool] = [:]
    
    func setTitle(hudStyle: WisdomHUDStyle, loadingStyle: WisdomLoadingStyle?, textPlaceStyle: WisdomTextPlaceStyle?) {
        nextView.infoLabel.text = "\(hudStyle.self)"
        leftView?.removeFromSuperview()
        leftView = nil
        
        switch hudStyle {
        case .succes:
            leftView = WisdomHUDSuccessView(size: 24, barStyle: .dark)
            (leftView as? WisdomHUDSuccessView)?.beginAnimation(isRepeat: false)
        case .error:
            leftView = WisdomHUDErrorView(size: 24, barStyle: .dark)
            (leftView as? WisdomHUDErrorView)?.beginAnimation(isRepeat: false)
        case .warning:
            leftView = WisdomHUDWarningView(size: 24, barStyle: .dark)
            (leftView as? WisdomHUDWarningView)?.beginAnimation(isRepeat: false)
        default: break
        }
        
        switch loadingStyle {
        case .system:
            nextView.infoLabel.text = "\(hudStyle.self)"+".system"
        
            leftView = WisdomHUDIndicatorView(size: 24, barStyle: .dark)
        case .rotate:
            nextView.infoLabel.text = "\(hudStyle.self)"+".rotate"
            
            leftView = WisdomHUDRotateView(size: 24, barStyle: .dark)
        case .progressArc:
            nextView.infoLabel.text = "\(hudStyle.self)"+".progressArc"
            
            leftView = WisdomHUDProgressArcView(size: 24, barStyle:.dark)
        case .tadpoleArc:
            nextView.infoLabel.text = "\(hudStyle.self)"+".tadpoleArc"
            
            leftView = WisdomHUDTadpoleArcView(size: 24, barStyle:.dark)
        default: break
        }
        
        switch textPlaceStyle {
        case .center: nextView.infoLabel.text = "\(hudStyle.self)"+".center"
        case .bottom: nextView.infoLabel.text = "\(hudStyle.self)"+".bottom"
        default: break
        }
        
        if let vi = leftView {
            contentView.addSubview(vi)
            
            vi.snp.makeConstraints({ make in
                make.left.equalTo(nextView).offset(35)
                make.centerY.equalTo(contentView)
                make.width.height.equalTo(24)
            })
        }
    }
}


// 下级图标-视图
class CustomNextView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "G_Next_Gray"))

    let infoLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.white
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(white: 0, alpha: 0.8)
        addSubview(imageView)
        
        addSubview(infoLabel)
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-12)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension String {
    /// 十六进制字符串颜色转为UIColor
    /// - Parameter alpha: 透明度
    func uicolor(alpha: CGFloat = 1.0) -> UIColor {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = self
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }

        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(startIndex, offsetBy: 4)...])).scanHexInt64(&blue)

        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}
